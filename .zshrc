# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ALIASES
# simple aliases
alias ls='ls' # use lsd instead of ls (not available Ubuntu 20.04)
alias ll='ls -G'
alias la='ls -1alG'

alias tree='tree -C'

alias cat='batcat' # use bat (batcat) instead of cat
alias df='duf' # use duf instead of df

# git aliases
alias gs='git status'
alias gaa='git add --all'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gl='git log --oneline --decorate --graph'
alias gba='git branch -a'

# quarto aliases
alias q='quarto'
alias qp='quarto preview'
alias qph='quarto preview --to html'
alias qpp='quarto preview --to pdf'
alias qr='quarto render'
alias qrh='quarto render --no-clean --to html'
alias qrp='quarto render --no-clean --to pdf'
alias qpub='quarto publish gh-pages'

# suffix aliases
# open md, txt, qmd, r files in VS Code
alias -s md=code
alias -s txt=code
alias -s qmd=code
alias -s r=code

# functions

# list directory contents after changing directory
function cd() {
    builtin cd "$@" && ll
}


source /home/vscode/.antidote/antidote.zsh
antidote load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
