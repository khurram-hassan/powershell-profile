#If the file does not exist, create it.
if (-not(Test-Path -Path $PROFILE -PathType Leaf)) {
     try {
         # Detect Version of Powershell & Create Profile directories if they do not exist.
         if ($PSVersionTable.PSEdition -eq "Core" ) { 
             if (!(Test-Path -Path ($env:userprofile + "\Documents\Powershell"))) {
                 New-Item -Path ($env:userprofile + "\Documents\Powershell") -ItemType "directory"
             }
         }
         elseif ($PSVersionTable.PSEdition -eq "Desktop") {
             if (!(Test-Path -Path ($env:userprofile + "\Documents\WindowsPowerShell"))) {
                 New-Item -Path ($env:userprofile + "\Documents\WindowsPowerShell") -ItemType "directory"
             }
         }

         Invoke-RestMethod https://raw.githubusercontent.com/khurram-hassan/powershell-profile/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
         Write-Host "The profile @ [$PROFILE] has been created."
        write-host "if you want to add any persistent components, please do so at
        [$HOME\Documents\PowerShell\Profile.ps1] as there is an updater in the installed profile 
        which uses the hash to update the profile and will lead to loss of changes"
     }
     catch {
        throw $_.Exception.Message
     }
 }
# If the file already exists, show the message and do nothing.
 else {
		 Get-Item -Path $PROFILE | Move-Item -Destination oldprofile.ps1 -Force
    Invoke-RestMethod https://raw.githubusercontent.com/khurram-hassan/powershell-profile/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
    Write-Host "The profile @ [$PROFILE] has been created and old profile removed."
         write-host "Please back up any persistent components of your old profile to [$HOME\Documents\PowerShell\Profile.ps1]
         as there is an updater in the installed profile which uses the hash to update the profile 
         and will lead to loss of changes"
 }
& $profile

# OMP Install
#
winget install -e --accept-source-agreements --accept-package-agreements JanDeDobbeleer.OhMyPosh

Install-Module -Name Terminal-Icons -Repository PSGallery

winget install GNU.Nano

# Font Install
#Invoke-RestMethod https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip?WT.mc_id=-blog-scottha -o cove.zip
#Invoke-RestMethod "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip" -o FiraCode.zip
# Get all installed font families
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families

# Check if FiraCode NF is installed
if ($fontFamilies -notcontains "FiraCode NF") {
    
    # Download and install FiraCode NF
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip", ".\FiraCode.zip")
    #$webClient.DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip", ".\CascadiaCode.zip")

    Expand-Archive -Path ".\FiraCode.zip" -DestinationPath ".\FiraCode" -Force
    $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
    Get-ChildItem -Path ".\FiraCode" -Recurse -Filter "*.ttf" | ForEach-Object {
        If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {        
            # Install font
            $destination.CopyHere($_.FullName, 0x10)
        }
    }

    # Clean up
    Remove-Item -Path ".\FiraCode" -Recurse -Force
    Remove-Item -Path ".\FiraCode.zip" -Force
}


# Choco install
#
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Terminal Icons Install
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
