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
