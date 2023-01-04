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
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
