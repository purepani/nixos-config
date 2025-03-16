$env.config.hooks.command_not_found = {
    |command_name|
    print (command-not-found $command_name | str trim)
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}
