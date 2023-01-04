cd  $env:USERPROFILE

Set-ExecutionPolicy Unrestricted -Scope CurrentUser

#Run as admin
irm https://raw.githubusercontent.com/asheroto/winget-installer/master/winget-install.ps1 | iex 


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
#Create new profile
New-Item $PROFILE

#Add path varible to profile script
Add-Content -Path $PROFILE -Value '$env:Path += ";$env:USERPROFILE\AppData\Local\Programs\oh-my-posh\bin"'

#Add path user script to powershell profile
Add-Content -Path $PROFILE -Value ".config\powershell\user_profile.ps1"

#Return to user profile folder
cd  $env:USERPROFILE

#Download Nerd Fonts , only root
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git

cd nerd-fonts

#Download CascadiaCode font
git sparse-checkout add patched-fonts/CascadiaCode

#Install CascadiaCode font
./install.ps1 CascadiaCode -WindowsCompatibleOnly

#Return to user profile folder
cd  $env:USERPROFILE

#Remove Nerd Fonts git repo locally
if((Test-Path("$Env:USERPROFILE\nerd-fonts")))
{
    Remove-Item -Path "$Env:USERPROFILE\nerd-fonts" -Force -Recurse
}

#Remove Scoop installation script
if((Test-Path("$Env:USERPROFILE\install.ps1")))
{
    Remove-Item -Path "$Env:USERPROFILE\install.ps1" -Force
}

#Remove winget installation script
if((Test-Path("$Env:USERPROFILE\winget-install.ps1")))
{
    Remove-Item -Path "$Env:USERPROFILE\winget-install.ps1" -Force
}


## Fix font and background of Terminal ##
$font = "CaskaydiaCove NF Mono"
$file = "$Env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$bgPathNormal = "$Env:USERPROFILE\.config\powershell\TerminalBackground.jpg"
$bgPath = $bgPathNormal.Replace("\","\\")

$default_regex = '(?<="defaults": {},)'
if((Get-Content $file) -match $default_regex)
{
    $default_regex_replace = '(?<="defaults": )[^"]*'
    (Get-Content $file) -replace $default_regex_replace, "`n`t`t{`n`t`t`t$([char]34)font$([char]34):`n`t`t`t{`n`t`t`t`t$([char]34)face$([char]34): $([char]34)$font$([char]34)`n`t`t`t},`n`t`t`t$([char]34)backgroundImage$([char]34): $([char]34)$bgPath$([char]34)`n`t`t}," | Set-Content $file
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
            (Get-Content $file) -replace $Face_regex_Replace, $font | Set-Content $file

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

#Add PowerShell Profile Script
Invoke-WebRequest -Uri https://raw.githubusercontent.com/canix1/TerminalTheme/main/user_profile.ps1 -OutFile "$Env:USERPROFILE\.config\powershell\user_profile.ps1" 

#Download background image
Invoke-WebRequest -Uri https://github.com/canix1/TerminalTheme/raw/main/TerminalBackground.jpg -OutFile $bgPathNormal

#Download oh-my-posh theme
Invoke-WebRequest -Uri https://raw.githubusercontent.com/canix1/TerminalTheme/main/canix.omp.json -Outfile "$Env:USERPROFILE\.config\powershell\canix.omp.json"

exit