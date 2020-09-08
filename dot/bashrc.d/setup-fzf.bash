if which fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude ".git" .'
elif which ag >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
else 
    export FZF_DEFAULT_COMMAND='find . -name .git -prune -o -print'
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview='test -d {} || bat --style=numbers --color=always {}'"
