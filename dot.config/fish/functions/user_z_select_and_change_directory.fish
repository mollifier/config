# require
# https://github.com/jethrokuan/z
# https://github.com/junegunn/fzf
function user_z_select_and_change_directory -d 'Select z directory and change directory'
    set -l selector fzf
    set -l selector_options '--no-sort --reverse --ansi --color bg+:13,hl:3,pointer:7'

    if not type -qf $selector
        echo "ERROR: '$selector' not found." 1>&2
        return 1
    end

    z -l | eval $selector $selector_options | sed 's/^[^\s][^\s]*\s\s*//' | read -l select
    [ -n "$select" ]; and cd -- "$select"
    commandline -f repaint
end
