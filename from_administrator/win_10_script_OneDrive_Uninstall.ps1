write-host "--------------Trying Uninstall OneDrive"
Write-Output "Kill OneDrive process"
taskkill.exe /F /IM "OneDrive.exe"

Write-Output "Remove OneDrive 32"
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
Write-Output "Remove OneDrive 64"
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}
Start-Sleep 3
Write-Output "Removing OneDrive leftovers"

Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"
#######################################
Write-Output "Removing OneDrive leftovers, check if directory is empty before removing"
# check if directory is empty before removing:
Start-Sleep 3
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
	Get-ChildItem -Path "$env:userprofile\OneDrive" -File -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
}
Get-ChildItem -Path "$env:localappdata\Microsoft\OneDrive" -File -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item

Write-Output "Disable OneDrive via Group Policies"

IF (!(Test-Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive))
{
	New-Item -Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive -Name DisableFileSyncNGSC -PropertyType DWord -Value 1 -Force

#######################################
Write-Output "Remove Onedrive from explorer sidebar"
New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
Remove-PSDrive "HKCR"
######################################

# Thank you Matthew Israelsson
Write-Output "Removing run hook for new users"
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "hku\Default"

Write-Output "Removing startmenu entry"
Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

Write-Output "Removing scheduled task"
#Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false
Get-ScheduledTask 'OneDrive*' | Disable-ScheduledTask



Write-Output "Removing CloudStore from registry if it exists"
$CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
If (Test-Path $CloudStore) {
	taskkill.exe /F /IM "explorer.exe"
	Remove-Item $CloudStore -Recurse -Force
	}
Start-Process explorer