write-host "----Trying disable Adobe Acrobat Updater service"
get-service AdobeARMservice | where {$_.status -eq 'running'} | stop-service -Force -PassThru
set-service AdobeARMservice -StartupType Disabled
# Отключение задачи
Get-ScheduledTask "Adobe Acrobat Update Task" | Disable-ScheduledTask
write-host "----Disable Adobe Acrobat Update"
#### Off internet login windows, rename file JSByteCodeWin.bin
write-host "----rename file JSByteCodeWin.bin"
$path1_64_JS="c:\Program Files\Adobe\Acrobat DC\Acrobat\Javascripts\JSByteCodeWin.bin"
$path1_86_JS="c:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Javascripts\JSByteCodeWin.bin"
$path2_64_JS="c:\Program Files\Adobe\Acrobat Reader DC\Reader\Javascripts\JSByteCodeWin.bin"
$path2_86_JS="c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\Javascripts\JSByteCodeWin.bin"
$path3_86_JS="C:\Program Files (x86)\Adobe\Acrobat Reader 2020\Reader\Javascripts\JSByteCodeWin.bin"
IF (Test-Path $path1_64_JS){Rename-Item -Path $path1_64_JS -NewName "JSByteCodeWin_111.bin"}
IF (Test-Path $path1_86_JS){Rename-Item -Path $path1_86_JS -NewName "JSByteCodeWin_111.bin"}
IF (Test-Path $path2_64_JS){Rename-Item -Path $path2_64_JS -NewName "JSByteCodeWin_111.bin"}
IF (Test-Path $path2_86_JS){Rename-Item -Path $path2_86_JS -NewName "JSByteCodeWin_111.bin"}
IF (Test-Path $path3_86_JS){Rename-Item -Path $path3_86_JS -NewName "JSByteCodeWin_111.bin"}
###c:\Program Files (x86)\Adobe\Acrobat Reader 2020\Reader\AcroApp\RUS\Viewer.aapp
IF (Test-Path "c:\Program Files (x86)\Adobe\Acrobat Reader 2020")
{Copy-Item -Path ".\win_10_script_Adobe_DC_admin_Viewer.aapp" -Destination "c:\Program Files (x86)\Adobe\Acrobat Reader 2020\Reader\AcroApp\RUS\Viewer.aapp"}
IF (Test-Path "c:\Program Files (x86)\Adobe\Acrobat Reader DC")
{Copy-Item -Path ".\win_10_script_Adobe_DC_admin_Viewer.aapp" -Destination "c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroApp\RUS\Viewer.aapp"}
IF (Test-Path "c:\Program Files (x86)\Adobe\Acrobat DC")
{Copy-Item -Path ".\win_10_script_Adobe_DC_admin_Viewer.aapp" -Destination "c:\Program Files (x86)\Adobe\Acrobat DC\Reader\AcroApp\RUS\Viewer.aapp"}
################### Function Body
function AdobeBody
{
IF (!(Test-Path $PathAdobeDC2))
{
	New-Item -Path $PathAdobeDC2 -Force
}
New-ItemProperty -Path $PathAdobeDC1 -Name bUpdater -Value 0 -Force
New-ItemProperty -Path $PathAdobeDC1 -Name bAcroSuppressUpsell -Value 0 -Force

###### Service plugin update
New-ItemProperty -Path $PathAdobeDC2 -Name bUpdater -Value 0 -Force
######## Non-storage services
#bToggleAdobeDocumentServices: 1 disables all Document Cloud service access.
#bToggleAdobeSign: 1 disables Adobe Send for Signature/Share.
#bTogglePrefsSync: 1 disables preference synchronization across devices.
#bToggleFillSign: 1 disables and locks the Fill and Sign feature.
#bToggleSendAndTrack: 1 disables and locks the Send and Track feature.
#bAdobeSendPluginToggle 0 disables
New-ItemProperty -Path $PathAdobeDC2 -Name bToggleAdobeDocumentServices -Value 1 -Force
#New-ItemProperty -Path $PathAdobeDC2 -Name bToggleAdobeSign -Value 1 -Force
#New-ItemProperty -Path $PathAdobeDC2 -Name bTogglePrefsSync -Value 1 -Force
#New-ItemProperty -Path $PathAdobeDC2 -Name bToggleFillSign -Value 1 -Force
#New-ItemProperty -Path $PathAdobeDC2 -Name bToggleSendAndTrack -Value 1 -Force
#New-ItemProperty -Path $PathAdobeDC2 -Name bAdobeSendPluginToggle -Value 0 -Force
######### Cloud storage
###### 1 disables third party storage solutions such as Dropbox, Google Drive, etc. Provider-specific preferences can override this setting.
New-ItemProperty -Path $PathAdobeDC2 -Name bToggleWebConnectors -Value 1 -Force
## Document Cloud services are enabled by default. 1 disables Document Cloud storage.
New-ItemProperty -Path $PathAdobeDC2 -Name bToggleDocumentCloud -Value 1 -Force
}
######################################## Adobe Acrobat (Continuous)
$PathAdobeDC1="HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cServices"
$PathAdobeDC2="HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cServices"
AdobeBody
######################################## Adobe Reader DC
$PathAdobeDC1="HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown"
$PathAdobeDC2="HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\cServices"
AdobeBody
######################################## Adobe Reader Classic 2020
$PathAdobeDC1="HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\2020\FeatureLockDown"
$PathAdobeDC2="HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\2020\FeatureLockDown\cServices"
AdobeBody

