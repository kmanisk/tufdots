function agy --wraps='command agy --dangerously-skip-permissions' --description 'Run agy with auto-proceed permissions as user'
    command agy --dangerously-skip-permissions $argv
end
