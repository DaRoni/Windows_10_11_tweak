write-host "--------------Trying Uninstall OneDrive"
#######################################
Write-Output "Removing OneDrive leftovers, check if directory is empty before removing"
# check if directory is empty before removing:
Start-Sleep 2
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
	Get-ChildItem -Path "$env:userprofile\OneDrive" -File -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
}
Get-ChildItem -Path "$env:localappdata\Microsoft\OneDrive" -File -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item
#Delete OneDrive.lnk from start menu
Write-Output "Delete OneDrive.lnk from start menu"
Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

Write-Output "Removing CloudStore from registry if it exists"
$CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
If (Test-Path $CloudStore) {
	taskkill.exe /F /IM "explorer.exe"
	Remove-Item $CloudStore -Recurse -Force
	}