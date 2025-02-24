# 💅
# if [ ! -S ~/.ssh/ssh_auth_sock ]; then
#   eval `ssh-agent`
#   ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
# fi
# export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
# ssh-add -l > /dev/null || ssh-add

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $ZDOTDIR/.antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme romkatv/powerlevel10k 

# Tell Antigen that you're done.
antigen apply

eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

source $HOME/.zshenv

# aliases
alias v='nvim'
alias t='tmux-sessionizer'
alias cat='bat'
alias pn='pnpm'
alias ydl='yt-dlp --no-playlist --downloader "aria2c" --downloader-args "-j 16 -s 16 -x 16 -k 1M" -f"bestvideo[height<=720]+bestaudio/best[height<=720]" -o "%(title)s.%(ext)s" -N 16 --extractor-args "youtube:formats=dashy"'
alias ydlp='yt-dlp --downloader "aria2c" --downloader-args "-j 16 -s 16 -x 16 -k 1M" -f"bestvideo[height<=720]+bestaudio/best[height<=720]" --download-archive archive.txt -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" -N 16 --extractor-args "youtube:formats=dashy"
yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" -o "%(title)s.%(ext)s" '
alias sptdl='spotdl --output "{artist}/{album}/{track-number} - {title}.{output-ext}"'
# alias mm='ncmpcpp'
alias nw='newsboat'
alias ghstar='echo https://github.com/$(gh api user/starred --template "{{range .}}{{.full_name|color \"yellow\"}} ({{timeago .updated_at}}){{\"\\n\"}}{{end}}" | fzf)'
alias y='yazi'
alias pf='PASSWORD_STORE_ENABLE_EXTENSIONS=true pass fzf'
alias hmm='cat ~/Developer/notes/bo*.md | grep "-" | shuf -n 1'
# alias rem='v ~/Developer/notes/reminder.md' # just use gcal

# uhhh 
alias g++='g++-14'
alias gcc='gcc-14'
# alias ghc='ghc-9.4'
alias python='python3'
alias py='python3'

# 🔒
setopt HIST_IGNORE_SPACE
alias jrnl=" jrnl"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

f() {
    local selected="$(fzf)"
    if [ -n "$selected" ]; then
        open "$selected"
    fi
}

# function td() {
#     local file=~/Developer/notes/today/$(date +%d-%m-%y).md
#     local today_date=$(date +%d-%m-%y)  # Today's date in DD-MM-YY format
#
#     if [[ -f $file && -s $file ]]; then
#         cat "$file"
#     else
#         {
#             echo "Date: $today_date"
#             echo ""
#         } >> "$file"
#         nvim "$file"
#     fi
# }

function wk() {
    local file=~/Developer/notes/week/$(date +%V).md
    local start_date=$(date -v-mon -v+0d +%d-%m-%y)  # start of the week (monday)
    local end_date=$(date -v-sun -v+7d +%d-%m-%y)    # end of the week (sunday)

    if [[ "$1" == "--edit" ]]; then
        if [[ ! -f $file ]]; then
            {
                echo "# Week Start: $start_date"
                echo "# Week End: $end_date"
                echo ""
            } >> "$file"
        fi
        nvim "$file"
    else
        if [[ ! -f $file ]]; then
            {
                echo "# Week Start: $start_date"
                echo "# Week End: $end_date"
                echo ""
            } >> "$file"
            nvim "$file"
        else
            cat "$file"
        fi
    fi
}

countdown() {
    end_time=$(( $(date '+%s') + $1 ))
    while [ $end_time -ge $(date +%s) ]; do
        remaining=$(( end_time - $(date +%s) ))
        printf '%02d:%02d:%02d\r' $((remaining / 3600)) $(( (remaining % 3600) / 60 )) $((remaining % 60))
        sleep 0.1
    done
    printf '\nTime is up!\n'
}


stopwatch() {
    start=$(date +%s)
    while true; do
        elapsed=$(( $(date +%s) - start ))
        printf '%02d:%02d:%02d\r' $((elapsed / 3600)) $(( (elapsed % 3600) / 60 )) $((elapsed % 60))
        sleep 0.1
    done
}

# https://discussions.apple.com/thread/254859103?sortBy=rank
setbg () { automator -i "${1}" ~/Documents/setDesktopPix.workflow }


# *vim* keybinds
bindkey -v

# restore history search 
bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward

# https://docs.brew.sh/Shell-Completion
autoload -Uz compinit
compinit

# https://apple.stackexchange.com/a/427568/571644
setopt SHARE_HISTORY

[ -f "/Users/ag/.ghcup/env" ] && . "/Users/ag/.ghcup/env" # ghcup-env
