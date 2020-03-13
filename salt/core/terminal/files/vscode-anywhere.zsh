WORDCHARS='*?_-+.[]~=&,;:§!#$£%^¨(){}<>\@`°|"'"'"

unsetopt extendedglob
setopt norecexact
setopt nosharehistory
autoload -U bashcompinit && bashcompinit

#Functions
custom-backward-kill-word () {
    local WORDCHARS="${WORDCHARS}/"
    zle backward-kill-word
}
zle -N custom-backward-kill-word

custom-backward-word () {
    local WORDCHARS="${WORDCHARS}/"
    zle backward-word
}
zle -N custom-backward-word

custom-forward-word () {
    local WORDCHARS="${WORDCHARS}/"
    zle forward-word
}

# This speeds up pasting w/ autosuggest
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zle -N custom-forward-word

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

zstyle ':completion:*' completer _complete _prefix:-complete _prefix:-approximate

# Binkey
bindkey '^W' custom-backward-kill-word
bindkey "^[${terminfo[kbs]}" backward-kill-word
bindkey "^[w" vi-backward-kill-word
bindkey "$terminfo[kcuu1]" up-line-or-history
bindkey "$terminfo[kcud1]" down-line-or-history
bindkey '^U' backward-kill-line
bindkey "^[u" kill-whole-line

# Alias
alias lsblk='lsblk --output NAME,KNAME,FSTYPE,SIZE,TYPE,MOUNTPOINT,REV,VENDOR,MAJ:MIN,LABEL,PARTLABEL,RO,RM,STATE,RQ-SIZE,MIN-IO'
alias history='fc -li -100000'
alias h='fc -li -100000 | grep $(date -I)'

# Less
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
#export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export GROFF_NO_SGR=1

# Force tab to 4 chars
tabs -4
