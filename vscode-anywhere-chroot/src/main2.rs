use nix::mount::{mount, MsFlags};
use nix::sched::{unshare, CloneFlags};
use nix::sys::signal::{kill, Signal};
use nix::sys::wait::{waitpid, WaitPidFlag, WaitStatus};
use nix::unistd;
use nix::unistd::{fork, ForkResult};
use std::env;
use std::fs;
use std::io;
use std::io::prelude::*;
use std::os::unix::fs::symlink;
use std::os::unix::process::CommandExt;
use std::path::Path;
use std::path::PathBuf;
use std::process;
use std::string::String;
use tempdir::TempDir;

const NONE: Option<&'static [u8]> = None;

fn bind_mount(source: &Path, dest: &Path) {
    // println!("{:?} => {:?}", source, dest);
    if let Err(e) = mount(
        Some(source),
        dest,
        Some("none"),
        MsFlags::MS_BIND | MsFlags::MS_REC,
        NONE,
    ) {
        eprintln!(
            "failed to bind mount {} to {}: {}",
            source.display(),
            dest.display(),
            e
        );
    }
}

fn bind_mount_directory(entry: &fs::DirEntry) {
    //let mountpoint = PathBuf::from("/").join(entry.file_name());
    let mountpoint = PathBuf::from("/").join(entry.path().strip_prefix("/nix").unwrap());
    if let Err(e) = fs::create_dir(&mountpoint) {
        if e.kind() != io::ErrorKind::AlreadyExists {
            let e2: io::Result<()> = Err(e);
            e2.unwrap_or_else(|_| panic!("failed to create {}", &mountpoint.display()));
        }
    }

    bind_mount(&entry.path(), &mountpoint)
}

fn bind_mount_file(entry: &fs::DirEntry) {
    //let mountpoint = PathBuf::from("/").join(entry.file_name());
    let mountpoint = PathBuf::from("/").join(entry.path().strip_prefix("/nix").unwrap());
    fs::File::create(&mountpoint)
        .unwrap_or_else(|_| panic!("failed to create {}", &mountpoint.display()));

    bind_mount(&entry.path(), &mountpoint)
}

fn mirror_symlink(entry: &fs::DirEntry) {
    let path = entry.path();
    let target = fs::read_link(&path)
        .unwrap_or_else(|_| panic!("failed to resolve symlink {}", &path.display()));
    let link_path = PathBuf::from("/").join(entry.file_name());
    symlink(&target, &link_path).unwrap_or_else(|_| {
        panic!(
            "failed to create symlink {} -> {}",
            &link_path.display(),
            &target.display()
        )
    });
}

fn bind_mount_direntry(entry: io::Result<fs::DirEntry>) {
    let entry = entry.expect("error while listing from /nix directory");
    // do not bind mount an existing nix installation
    // if entry.file_name() == PathBuf::from("nix") {
    if entry.file_name() == PathBuf::from("nix") || entry.file_name() == PathBuf::from("home") || entry.file_name() == PathBuf::from("home/linuxbrew") {
        // println!("SKIP: {}", entry.path().display());
        return;
    }
    // else {
    //     println!("MOUNT: {}", entry.path().display());
    // }
    let path = entry.path();
    let stat = entry
        .metadata()
        .unwrap_or_else(|_| panic!("cannot get stat of {}", path.display()));
    if stat.is_dir() {
        // println!("{:?}", &entry);
        bind_mount_directory(&entry);
    } else if stat.is_file() {
        bind_mount_file(&entry);
    } else if stat.file_type().is_symlink() {
        mirror_symlink(&entry);
    }
}

fn run_chroot(nixdir: &Path, brewdir: &Path, rootdir: &Path, cmd: &str, args: &[String]) {
    let cwd = env::current_dir().expect("cannot get current working directory");
    let uid = unistd::getuid();
    let gid = unistd::getgid();

    unshare(CloneFlags::CLONE_NEWNS | CloneFlags::CLONE_NEWUSER).expect("unshare failed");

    // prepare pivot_root call:
    // rootdir must be a mount point

    mount(
        Some(rootdir),
        rootdir,
        Some("none"),
        MsFlags::MS_BIND | MsFlags::MS_REC,
        NONE,
    )
    .expect("failed to re-bind mount / to our new chroot");

    mount(
        Some(rootdir),
        rootdir,
        Some("none"),
        MsFlags::MS_PRIVATE | MsFlags::MS_REC,
        NONE,
    ).expect("failed to re-mount our chroot as private mount");

    // create the mount point for the old root
    // The old root cannot be unmounted/removed after pivot_root, the only way to
    // keep / clean is to hide the directory with another mountpoint. Therefore
    // we pivot the old root to /nix. This is somewhat confusing, though.
    let nix_mountpoint = rootdir.join("nix");
    fs::create_dir(&nix_mountpoint)
        .unwrap_or_else(|_| panic!("failed to create {}", &nix_mountpoint.display()));

    unistd::pivot_root(rootdir, &nix_mountpoint).unwrap_or_else(|_| {
        panic!(
            "pivot_root({},{})",
            rootdir.display(),
            nix_mountpoint.display()
        )
    });

    env::set_current_dir("/").expect("cannot change directory to /");

    // bind mount all / stuff into rootdir
    // the orginal content of / now available under /nix
    let nix_root = PathBuf::from("/nix");
    let dir = fs::read_dir(&nix_root).expect("failed to list /nix directory");
    for entry in dir {
        // println!("{:?}", entry);
        bind_mount_direntry(entry);
    }

    let brew_mountpoint = rootdir.join("home/homebrew");
    fs::create_dir_all(&brew_mountpoint)
        .unwrap_or_else(|_| panic!("failed to create {}", &brew_mountpoint.display()));

    // bind mount all / stuff into rootdir
    // the orginal content of / now available under /home/
    let brew_root = PathBuf::from("/nix/home");
    let dir = fs::read_dir(&brew_root).expect("failed to list /home directory");
    for entry in dir {
        // println!("{:?}", entry);
        bind_mount_direntry(entry);
    }

    // mount the store and hide the old root
    // we fetch brewdir under the old root
    let brew_store = nix_root.join(brewdir);
    mount(
        Some(&brew_store),
        "/home/homebrew",
        Some("none"),
        MsFlags::MS_BIND | MsFlags::MS_REC,
        NONE,
    )
    .unwrap_or_else(|_| panic!("failed to bind mount {} to /home/homebrew", brew_store.display()));

    // mount the store and hide the old root
    // we fetch nixdir under the old root
    let nix_store = nix_root.join(nixdir);
    mount(
        Some(&nix_store),
        "/nix",
        Some("none"),
        MsFlags::MS_BIND | MsFlags::MS_REC,
        NONE,
    )
    .unwrap_or_else(|_| panic!("failed to bind mount {} to /nix", nix_store.display()));

    // fixes issue #1 where writing to /proc/self/gid_map fails
    // see user_namespaces(7) for more documentation
    if let Ok(mut file) = fs::File::create("/proc/self/setgroups") {
        let _ = file.write_all(b"deny");
    }

    let mut uid_map =
        fs::File::create("/proc/self/uid_map").expect("failed to open /proc/self/uid_map");
    uid_map
        .write_all(format!("{} {} 1", uid, uid).as_bytes())
        .expect("failed to write new uid mapping to /proc/self/uid_map");

    let mut gid_map =
        fs::File::create("/proc/self/gid_map").expect("failed to open /proc/self/gid_map");
    gid_map
        .write_all(format!("{} {} 1", gid, gid).as_bytes())
        .expect("failed to write new gid mapping to /proc/self/gid_map");

    // restore cwd
    env::set_current_dir(&cwd)
        .unwrap_or_else(|_| panic!("cannot restore working directory {}", cwd.display()));

    let err = process::Command::new(cmd)
        .args(args)
        .env("NIX_CONF_DIR", "/nix/etc/nix")
        .exec();

    eprintln!("failed to execute {}: {}", &cmd, err);
    process::exit(1);
}

fn wait_for_child(child_pid: unistd::Pid, tempdir: TempDir, rootdir: &Path) {
    loop {
        match waitpid(child_pid, Some(WaitPidFlag::WUNTRACED)) {
            Ok(WaitStatus::Signaled(child, Signal::SIGSTOP, _)) => {
                let _ = kill(unistd::getpid(), Signal::SIGSTOP);
                let _ = kill(child, Signal::SIGCONT);
            }
            Ok(WaitStatus::Signaled(_, signal, _)) => {
                kill(unistd::getpid(), signal)
                    .unwrap_or_else(|_| panic!("failed to send {} signal to our self", signal));
            }
            Ok(WaitStatus::Exited(_, status)) => {
                tempdir.close().unwrap_or_else(|_| {
                    panic!(
                        "failed to remove temporary directory: {}",
                        rootdir.display()
                    )
                });
                process::exit(status);
            }
            Ok(what) => {
                tempdir.close().unwrap_or_else(|_| {
                    panic!(
                        "failed to remove temporary directory: {}",
                        rootdir.display()
                    )
                });
                eprintln!("unexpected wait event happend: {:?}", what);
                process::exit(1);
            }
            Err(e) => {
                tempdir.close().unwrap_or_else(|_| {
                    panic!(
                        "failed to remove temporary directory: {}",
                        rootdir.display()
                    )
                });
                eprintln!("waitpid failed: {}", e);
                process::exit(1);
            }
        };
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 4 {
        eprintln!("Usage: {} <nixpath> <command>\n", args[0]);
        process::exit(1);
    }
    let tempdir = TempDir::new("nix").expect("failed to create temporary directory for mount point");
    let rootdir = PathBuf::from(tempdir.path());

    let nixdir = fs::canonicalize(&args[1])
        .unwrap_or_else(|_| panic!("failed to resolve nix directory {}", &args[1]));

    let brewdir = fs::canonicalize(&args[2])
        .unwrap_or_else(|_| panic!("failed to resolve nix directory {}", &args[2]));

    match fork() {
        Ok(ForkResult::Parent { child, .. }) => wait_for_child(child, tempdir, &rootdir),
        Ok(ForkResult::Child) => run_chroot(&nixdir, &brewdir, &rootdir, &args[3], &args[4..]),
        Err(e) => {
            eprintln!("fork failed: {}", e);
        }
    };
}
