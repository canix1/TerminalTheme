#User Profile
clear-host


#Load Prompt config
Import-Module Terminal-Icons
Import-Module z

import-module -Name PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

function Get-ScriptDirectory { split-path $MyInvocation.ScriptName}
$PROMPT_CONFIG = Join-Path (Get-ScriptDirectory) 'canix.omp.json'

oh-my-posh init pwsh --config $PROMPT_CONFIG | Invoke-Expression

# Alias
Set-Alias vim nvim -scope global
Set-Alias ll ls -scope global
Set-Alias grep findstr -scope global
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe' -scope global
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe' -scope global
