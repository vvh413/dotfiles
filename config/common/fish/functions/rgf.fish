function rgf
    set RG_PREFIX "rga --files-with-matches"
    set file "$(
                FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
                        fzf --sort --preview="not test -z {}; and rga --pretty --context 5 {q} {}" \
                                --phony -q "$1" \
                                --bind "change:reload:$RG_PREFIX {q}" \
                                --preview-window="70%:wrap"
        )"
    echo "opening $file"
    xdg-open "$file"
end
