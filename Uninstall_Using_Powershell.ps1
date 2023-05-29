$Software = Read-Host -Prompt 'Input the name of software to uninstall'
$w64=Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | where-Object DisplayName -like $Software
$w32=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where-Object DisplayName -like $Software
Write-Output “Before::::”
if ($w64) {
write-Host $w64.DisplayVersion
} elseif ($w32) {
write-Host $w32.DisplayVersion
} else {
Write-Output “No Version Found”
}

# Modern websites require TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# requires -RunAsAdministrator

# Let’s go directly to the website and see what it lists as the current version
$BaseUri = “https://notepad-plus-plus.org”
$BasePage = Invoke-WebRequest -Uri $BaseUri -UseBasicParsing
$ChildPath = $BasePage.Links | Where-Object { $_.outerHTML -like ‘*Current Version*’ } | Select-Object -ExpandProperty href
# Now let’s go to the latest version’s page and find the installer
$DownloadPageUri = $BaseUri + $ChildPath
$DownloadPage = Invoke-WebRequest -Uri $DownloadPageUri -UseBasicParsing
# Determine bit-ness of O/S and download accordingly
if ( [System.Environment]::Is64BitOperatingSystem ) {
if (Test-Path (“C:\Program Files\Notepad++”)){
$DownloadUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.3/npp.8.5.3.Installer.x64.exe"
}else {
if (Test-Path (“C:\Program Files (x86)\Notepad++”)){
$DownloadUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.3/npp.8.5.3.Installer.x64.exe"
}
}
}
#Fix when it get 2 lines of the same URL


If ($DownloadUrl -ne $null){
Write-Host “Downloading the latest Notepad++ to the temp folder”
Invoke-WebRequest -Uri $DownloadUrl -OutFile “$env:TEMP\$( Split-Path -Path $DownloadUrl -Leaf )” | Out-Null
Write-Host “Installing the latest Notepad++”
Start-Process -FilePath “$env:TEMP\$( Split-Path -Path $DownloadUrl -Leaf )” -ArgumentList “/S” -Wait
}

$w64=Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | where-Object DisplayName -like ‘NotePad++*’
$w32=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where-Object DisplayName -like ‘NotePad++*’
Write-Output “After::::”
if ($w64) {
write-Host $w64.DisplayVersion
} elseif ($w32) {
write-Host $w32.DisplayVersion
} else {
Write-Output “No Version Found”
}
