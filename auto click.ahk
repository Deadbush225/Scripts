toggle = 0
#MaxThreadsPerHotkey 2

F9::
    Toggle := !Toggle
     While Toggle{
        click
        sleep 100
    }
return