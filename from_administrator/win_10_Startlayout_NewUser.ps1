############################################################
$OSver=[System.Environment]::OSVersion.Version.Build
# Imoprt Startlayout XML only for Windows 10 New Users from admin account
If ($OSver -lt 22000) {
write-host "-----------------Windows 10 Start Layout"
Import-StartLayout -LayoutPath .\win_10_Startlayout_NewUser.xml -MountPath "C:\"
}
#############################################################
####  For Windows 11 Pinned Apps
If ($OSver -gt 22000) {
write-host "-----------------Windows 11 Pinned Apps"
IF (!(Test-Path "%SystemDrive%\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin"))
{
New-Item -Path "%SystemDrive%\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin" -ItemType Directory}
Copy-Item -Path ".\start2.bin" -Destination "%SystemDrive%\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin"
}
