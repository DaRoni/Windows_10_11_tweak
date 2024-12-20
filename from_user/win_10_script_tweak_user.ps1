####################################################################
####################################################################
####################### 

Write-Output "Turning off Data Collection (Telemetry)"
$DataCollection4 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
If (Test-Path $DataCollection4) {Set-ItemProperty $DataCollection4  AllowTelemetry -Value 0}

write-host "------------------Trying disable Silent Apps Install"
IF (!(Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager))
{New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Force}
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -PropertyType DWord -Value 0 -Force

####################################################################
write-host "------------------Bing Search Disable on user"
IF (!(Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search))
{New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Force}
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -PropertyType DWord -Value 0 -Force
IF (!(Test-Path HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer))
{New-Item -Path HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force}
New-ItemProperty -Path HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -PropertyType DWord -Value 1 -Force

####################################################################
#Disables Web Search in Start Menu
Write-Output "Disabling Bing Search in Start Menu"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name BingSearchEnabled -Value 0
New-ItemProperty -Path "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name DisableSearchBoxSuggestions -PropertyType DWord -Value 1 -Force

#Stops the Windows Feedback Experience from sending anonymous data
    Write-Output "Stopping the Windows Feedback Experience program"
    $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
    If (!(Test-Path $Period)) { 
        New-Item $Period
    }
    Set-ItemProperty $Period PeriodInNanoSeconds -Value 0 

################ ContentDeliveryManager ##############################################
#Prevents bloatware applications from returning and removes Start Menu suggestions               
Write-Output "Adding Registry key to prevent bloatware apps from returning"
$registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    If (!(Test-Path $registryOEM)) {
        New-Item $registryOEM
    }
Set-ItemProperty -Path $registryOEM -Name ContentDeliveryAllowed -Value 0 -Force
Set-ItemProperty -Path $registryOEM -Name OemPreInstalledAppsEnabled -Value 0 -Force
Set-ItemProperty -Path $registryOEM -Name PreInstalledAppsEnabled -Value 0 -Force
Set-ItemProperty -Path $registryOEM -Name PreInstalledAppsEverEnabled -Value 0 -Force
Set-ItemProperty -Path $registryOEM -Name SilentInstalledAppsEnabled -Value 0 -Force
Set-ItemProperty -Path $registryOEM -Name SystemPaneSuggestionsEnabled -Value 0 -Force
New-ItemProperty -Path $registryOEM -Name SubscribedContentEnabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path $registryOEM -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 0 -Force
####################################################################
# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
# Отклонить предложение Microsoft Defender в "Безопасность Windows" о входе в аккаунт Microsoft
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force
####################################################################
# Display the recycle bin files delete confirmation dialog
$ShellState = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState
$ShellState[4] = 51
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState -PropertyType Binary -Value $ShellState -Force

write-host "------------------News(weather) Feeds Hide on taskbar"
IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds -Name ShellFeedsTaskbarViewMode -PropertyType DWord -Value 2 -Force

#######################################################################
# OneDrive
write-host "--------------OneDriveFileExplorerAd Hide"

IF (!(Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced))
{
	New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Force
}
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 0 -Force

#########################################
write-host "--------------DesktopIcons MyComputer"

IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWord -Value 0 -Force

write-host "-----------------ShowTaskViewButton"

IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force

write-host "---------------HideMergeConflicts"

IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force

write-host "------------------DisableAutoplay"
IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force

write-host "------------------SearchboxTaskbarMode"
IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 1 -Force

write-host "------------------Cortana Button Hide on taskbar"
IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 1 -Force

write-host "------------------Unpin from start Microsoft Store"
# 
$getstring = @'
[DllImport("kernel32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr GetModuleHandle(string lpModuleName);
[DllImport("user32.dll", CharSet = CharSet.Auto)]
internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);
public static string GetString(uint strId)
{
	IntPtr intPtr = GetModuleHandle("shell32.dll");
	StringBuilder sb = new StringBuilder(255);
	LoadString(intPtr, strId, sb, sb.Capacity);
	return sb.ToString();
}
'@
$getstring = Add-Type $getstring -PassThru -Name GetStr -Using System.Text
$unpinFromStart = $getstring[0]::GetString(5387)
$apps = (New-Object -Com Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
$apps | Where-Object { $_.Path -like "Microsoft.WindowsStore*" } | ForEach-Object {$_.Verbs() | Where-Object {$_.Name -eq $unpinFromStart} | ForEach-Object {$_.DoIt()}}
Remove-Variable getstring, unpinFromStart, apps

write-host "----Set default Outlook"
.\SetUserFTA\SetUserFTA.exe mailto Outlook.URL.mailto.15
write-host "----Set default Acrobat Reader 2020"
#.\SetUserFTA\SetUserFTA.exe .pdf AcroExch.Document.DC
.\SetUserFTA\SetUserFTA.exe .pdf AcroExch.Document.2020
write-host "----Set default Honeyview"
#.\SetUserFTA\SetUserFTA.exe .jpg Honeyview.jpg
#.\SetUserFTA\SetUserFTA.exe .jpeg Honeyview.jpeg
#.\SetUserFTA\SetUserFTA.exe .bmp Honeyview.bmp
#.\SetUserFTA\SetUserFTA.exe .gif Honeyview.gif
#.\SetUserFTA\SetUserFTA.exe .png Honeyview.png
#.\SetUserFTA\SetUserFTA.exe .tif Honeyview.tif
#.\SetUserFTA\SetUserFTA.exe .tiff Honeyview.tiff
#.\SetUserFTA\SetUserFTA.exe .webp Honeyview.webp
#.\SetUserFTA\SetUserFTA.exe .dng Honeyview.dng
write-host "----Set default MPC-HC(x64)"
.\SetUserFTA\SetUserFTA.exe .mp3 mplayerc64.mp3
.\SetUserFTA\SetUserFTA.exe .ogg mplayerc64.ogg
.\SetUserFTA\SetUserFTA.exe .wav mplayerc64.wav
.\SetUserFTA\SetUserFTA.exe .wma mplayerc64.wma
.\SetUserFTA\SetUserFTA.exe .ac3 mplayerc64.ac3
.\SetUserFTA\SetUserFTA.exe .amr mplayerc64.amr
.\SetUserFTA\SetUserFTA.exe .cda mplayerc64.cda
.\SetUserFTA\SetUserFTA.exe .avi mplayerc64.avi
.\SetUserFTA\SetUserFTA.exe .mpeg mplayerc64.mpeg
.\SetUserFTA\SetUserFTA.exe .mpg mplayerc64.mpg
.\SetUserFTA\SetUserFTA.exe .vob mplayerc64.vob
.\SetUserFTA\SetUserFTA.exe .ifo mplayerc64.ifo
.\SetUserFTA\SetUserFTA.exe .mkv mplayerc64.mkv
.\SetUserFTA\SetUserFTA.exe .webm mplayerc64.webm
.\SetUserFTA\SetUserFTA.exe .mp4 mplayerc64.mp4
.\SetUserFTA\SetUserFTA.exe .mov mplayerc64.mov
.\SetUserFTA\SetUserFTA.exe .3gp mplayerc64.3gp
.\SetUserFTA\SetUserFTA.exe .3gpp mplayerc64.3gpp
.\SetUserFTA\SetUserFTA.exe .flv mplayerc64.flv
.\SetUserFTA\SetUserFTA.exe .wmv mplayerc64.wmv
.\SetUserFTA\SetUserFTA.exe .m3u mplayerc64.m3u
.\SetUserFTA\SetUserFTA.exe .m3u8 mplayerc64.m3u8
.\SetUserFTA\SetUserFTA.exe .pls mplayerc64.pls
write-host "----Set default 7zip"
.\SetUserFTA\SetUserFTA.exe .zip 7-Zip.zip
.\SetUserFTA\SetUserFTA.exe .rar 7-Zip.zip
.\SetUserFTA\SetUserFTA.exe .7z 7-Zip.zip
####  For Windows 11
$OSver=[System.Environment]::OSVersion.Version.Build
If ($OSver -gt 22000) {
	write-host "-----------------Windows 11 "+$OSver
	IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced))
	{New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Force}
	    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -PropertyType DWord -Value 0 -Force #mini apps hide
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -PropertyType DWord -Value 0 -Force #mini apps hide
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarAl -PropertyType DWord -Value 0 -Force #start menu left
	IF (!(Test-Path 'HKCU:\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}'))
	{New-Item -Path 'HKCU:\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' -Force}
	    New-ItemProperty -Path 'HKCU:\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' -Name  System.IsPinnedToNameSpaceTree -PropertyType DWord -Value 0 -Force #Galery hide in explorer
	### Copilot Off
	IF (!(Test-Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot))
	{New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot -Force}
	    New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot -Name TurnOffWindowsCopilot -PropertyType DWord -Value 1 -Force
		}
# restart explorer	
Start-Process explorer