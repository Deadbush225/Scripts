<# Usage:
 
    ./compile.ps1 [-C <command> <Flags>]
 
<command>:
    C: Compile only
    C: Run only
    CR: Compile and Run [Default]

Flags:
    Loop: Turns on Loop mode of the script   

#>

# $ErrorActionPreference = "Stop"

# Must be the first statement in your script (not counting comments)
param(
    [string]$ScriptPath = $pwd,
    [string]$C = "CR",
    [switch]$L,
    [switch]$AddIcon=false
)

$ScriptPath = Get-Item $ScriptPath

$scriptFolder = $ScriptPath.FullName
$scriptName = $ScriptPath.Name # "Spotify Window Manager"
$ScriptPathWOExtension = $scriptFolder + "\" + $scriptName
    
$processOptions = @{
    FilePath     = "ahk2exe.exe"
    ArgumentList = '/in ".\' + $ScriptPathWOExtension + '.ahk' + '/out ".\' + $ScriptPathWOExtension + '.exe"' +  ( $AddIcon ? (' /icon ".\' + $ScriptPathWOExtension + '.ico"') : "")
}

$iterations = if ($L) { 100 } else { 1 };

for ($i = 0; $i -lt $iterations; $i++) {
    try {
        Stop-Process -Name $scriptName -ErrorAction stop
    }
    catch {
        Write-Host $scriptName "is not yet started"
    }
    
    
    if ($C.Contains("C")) {
        Write-Host "Contains C"
        Start-Process @processOptions
    }
    
    if ($C.Contains("R")) {
        Write-Host "Contains R"
        Start-Sleep -Seconds 2
        Start-Process -FilePath $scriptName".exe"
    }

    if (($iterations - 1) -eq $i) {
        # Write-Output("Command ran")
        Exit
    }

    $title = "Repeating command"
    $message = "Run again or Exit?"

    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Run", `
        "Recompile and run again."

    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", `
        "Exit the script."

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

    $result = $host.ui.PromptForChoice($title, $message, $options, 0)

    switch ($result) {
        0 { continue }
        1 { Exit }
    }
}