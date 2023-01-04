cd  $env:USERPROFILE

Set-ExecutionPolicy Unrestricted -Scope CurrentUser

#Run as admin
Invoke-WebRequest -Uri https://raw.githubusercontent.com/asheroto/winget-installer/master/winget-install.ps1 -OutFile .\winget-install.ps1

.\winget-install.ps1


#iwr -useb get.scoop.sh | iex

irm get.scoop.sh -outfile 'install.ps1'

.\install.ps1 -RunAsAdmin

scoop install curl sudo jq

winget install -e --id Git.Git --accept-source-agreements

$env:Path += ';C:\Program Files\Git\cmd'    

scoop install neovim gcc

winget install JanDeDobbeleer.OhMyPosh -s winget --accept-source-agreements

$env:Path += ";$env:USERPROFILE\AppData\Local\Programs\oh-my-posh\bin"

scoop install nvm

nvm install 14.16.0

nvm use 14.16.0

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser

Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Scope CurrentUser

Install-Module -Name z -Force -Scope CurrentUser -AllowClobber

Install-module -Name PSReadLine -MinimumVersion 2.2.5 -Scope CurrentUser -Force -SkipPublisherCheck

if(-not (Test-Path("$Env:USERPROFILE\.config")))
{
    New-Item -Path "$Env:USERPROFILE\.config" -ItemType Directory
}

if(-not (Test-Path("$Env:USERPROFILE\.config\powershell")))
{
    New-Item -Path "$Env:USERPROFILE\.config\powershell" -ItemType Directory
}

New-Item $PROFILE

Add-Content -Path $PROFILE -Value '$env:Path += ";$env:USERPROFILE\AppData\Local\Programs\oh-my-posh\bin"'

Add-Content -Path $PROFILE -Value ".config\powershell\user_profile.ps1"

cd  $env:USERPROFILE

git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git

cd nerd-fonts

git sparse-checkout add patched-fonts/CascadiaCode

./install.ps1 CascadiaCode -WindowsCompatibleOnly

cd  $env:USERPROFILE

if(-not (Test-Path("$Env:USERPROFILE\nerd-fonts")))
{
    Remove-Item -Path "$Env:USERPROFILE\nerd-fonts" -Force
}

if(-not (Test-Path("$Env:USERPROFILE\install.ps1")))
{
    Remove-Item -Path "$Env:USERPROFILE\install.ps1" -Force
}


if(-not (Test-Path("$Env:USERPROFILE\winget-install.ps1")))
{
    Remove-Item -Path "$Env:USERPROFILE\winget-install.ps1" -Force
}


## Fix font and background of Terminal ##
$font = 'CaskaydiaCove NF Mono'
$file = "$Env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$bgPath = "$Env:USERPROFILE\.config\powershell\TerminalBackground.jpg"
$bgPath = $bgPath.Replace("\","\\")

$default_regex = '(?<="defaults": {},)'
if((Get-Content $file) -match $default_regex)
{
    $default_regex_replace = '(?<="defaults": )[^"]*'
    (Get-Content $file) -replace $default_regex_replace, "`n`t`t{`n`t`t`t$([char]34)font$([char]34):`n`t`t`t{`n`t`t`t`t$([char]34)face$([char]34): $([char]34)CaskaydiaCove NF Mono$([char]34)`n`t`t`t},`n`t`t`t$([char]34)backgroundImage$([char]34): $([char]34)$bgPath$([char]34)`n`t`t}," | Set-Content $file
}
else
{
    $Font_regex = '(?<="font":)'
    #Replace fonts
    if((Get-Content $file) -match $Font_regex)
    {
        Write-Verbose -Message "Found font" 
        $Face_regex = '(?<="face":)'
        #Replace face
        if((Get-Content $file) -match $Face_regex)
        {
            Write-Verbose -Message "Found face" 
            $Face_regex_Replace = '(?<="face": ")[^"]*'
            (Get-Content $file) -replace $Face_regex_Replace, 'CaskaydiaCove NF Mono' | Set-Content $file

        }
    }
    #Replace background
    $Background_regex = '(?<="backgroundImage":)'
    #Replace background image
    if((Get-Content $file) -match $Background_regex)
    {
        Write-Verbose -Message "Found backgroundImage"
        $Background_regex_Replace = '(?<="backgroundImage": ")[^"]*'
        (Get-Content $file) -replace $Background_regex_Replace, $bgPath | Set-Content $file

    }

}
##