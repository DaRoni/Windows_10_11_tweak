
#taskkill.exe /F /IM "explorer.exe"
####################### Отключаем телеметрию и саму службу
write-host "--------------Trying disable Microsoft Compatibility Telemetry service"
#get-service DiagTrack | where {$_.status -eq 'running'} | stop-service -Force -PassThru
#set-service DiagTrack -StartupType Disable -ErrorAction SilentlyContinue
#get-service dmwappushservice | where {$_.status -eq 'running'} | stop-service -Force -PassThru
#set-service dmwappushservice -StartupType Disable -ErrorAction SilentlyContinue

$services = @(
    "diagnosticshub.standardcollector.service"     # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                    # Diagnostics Tracking Service
    "dmwappushservice"                             # WAP Push Message Routing Service (see known issues)
    "lfsvc"                                        # Geolocation Service
    "MapsBroker"                                   # Downloaded Maps Manager
    "NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
    "SharedAccess"                                 # Internet Connection Sharing (ICS)
    "TrkWks"                                       # Distributed Link Tracking Client
    "WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
    "XblAuthManager"                               # Xbox Live Auth Manager
    "XblGameSave"                                  # Xbox Live Game Save Service
    "XboxNetApiSvc"                                # Xbox Live Networking Service
    "XboxGipSvc"                                   #Disables Xbox Accessory Management Service
    "Fax"                                          #Disables fax
    "fhsvc"                                        #Disables fax histroy
    "AJRouter"                                     #Disables (needed for AllJoyn Router Service)
    "MSDTC"                                        # Disables Distributed Transaction Coordinator
    "WpcMonSvc"                                    #Disables Parental Controls
	"UCPD" #Disable userChoice Protection Driver
)

foreach ($service in $services) {
    # -ErrorAction SilentlyContinue is so it doesn't write an error to stdout if a service doesn't exist

    Write-Host "Setting $service StartupType to Disabled"
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled
} 

# Отключение задач диагностического отслеживания в Планировщике задач
$tasks = @(
"klcp_update",
"klcp_update",
"OneDrive Standalone Update Task*",
"OneDrive*",
"OfficeTelemetry*",
"appuriverifierdaily",
"appuriverifierinstall",
"BgTaskRegistrationMaintenanceTask",
"Consolidator",
"DmClient",
"DmClientOnScenarioDownload",
"EDP Policy Manager",
"EnableLicenseAcquisition",
"FamilySafetyMonitor",
#"FamilySafetyMonitorToastTask",
"FamilySafetyRefreshTask",
"File History (maintenance mode)",
"FODCleanupTask",
"GatherNetworkInfo",
"MapsToastTask",
"MapsUpdateTask",
"Microsoft Compatibility Appraiser",
"Microsoft-Windows-DiskDiagnosticDataCollector",
"MNO Metadata Parser",
"NetworkStateChangeTask",
"ProgramDataUpdater",
"Proxy",
"QueueReporting",
"SpeechModelDownloadTask",
"StartupAppTask",
"TempSignedLicenseExchange",
"UsbCeip",
"WinSAT",
"XblGameSaveTask",
"UCPD velocity",
"MareBackup")

Foreach ($task in $tasks)
{
	Get-ScheduledTask $task | Disable-ScheduledTask
}
####################################### Disable UCPD UserChoice Protection Driver

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\UCPD" -Name "Start" -Value 4 -PropertyType DWORD -Force

####################################### autostart off
write-host "------------------Delete Eraser from autostart"
Remove-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Run -Name Eraser -Force

####################################################################
#Turns off Data Collection via the AllowTelemtry key by changing it to 0
Write-Output "Turning off Data Collection (Telemetry)"
$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
$DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
$DataCollection4 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
If (Test-Path $DataCollection1) {Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0}
If (Test-Path $DataCollection2) {Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0}
If (Test-Path $DataCollection3) {Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0}
If (Test-Path $DataCollection4) {Set-ItemProperty $DataCollection4  AllowTelemetry -Value 0}
####################################################################
# Rename system drive name OS
Set-Volume -DriveLetter C -NewFileSystemLabel "OS"
####################################################################
#Disables Windows Feedback Experience
    Write-Output "Disabling Windows Feedback Experience program"
    $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    If (Test-Path $Advertising) {
        Set-ItemProperty $Advertising Enabled -Value 0 
    }
            
    #Stops Cortana from being used as part of your Windows Search Function
    Write-Output "Stopping Cortana from being used as part of your Windows Search Function"
    $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    If (Test-Path $Search) {
        Set-ItemProperty $Search AllowCortana -Value 0 
    }

#########Disables Web Search in Start Menu
    Write-Output "Disabling Bing Search in Start Menu"
    $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
    If (!(Test-Path $WebSearch)) {
        New-Item $WebSearch
    }
    Set-ItemProperty -Path $WebSearch -Name DisableWebSearch -Value 1
	New-ItemProperty -Path "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name DisableSearchBoxSuggestions -PropertyType DWord -Value 1 -Force
		
#Stops the Windows Feedback Experience from sending anonymous data
    Write-Output "Stopping the Windows Feedback Experience program"
    $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
    If (!(Test-Path $Period)) { 
        New-Item $Period
    }
    Set-ItemProperty $Period PeriodInNanoSeconds -Value 0 

#Prevents bloatware applications from returning and removes Start Menu suggestions               
    Write-Output "Adding Registry key to prevent bloatware apps from returning"
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"    
    If (!(Test-Path $registryPath)) { 
        New-Item $registryPath
    }
    Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 

################ ContentDeliveryManager ##############################################
#Prevents bloatware applications from returning and removes Start Menu suggestions               
Write-Output "Trying disable Silent Apps Install"
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

write-host "------------------Cortana Button Hide on taskbar"
IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced))
{New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Force}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 1 -Force
Write-Host "Disabling Cortana"
$Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
$Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
$Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
If (!(Test-Path $Cortana1)) {New-Item $Cortana1}
Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0
If (!(Test-Path $Cortana2)) {New-Item $Cortana2}
Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1
Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1
If (!(Test-Path $Cortana3)) {New-Item $Cortana3}
Set-ItemProperty $Cortana3 HarvestContacts -Value 0

####################################################################
write-host "--------------DesktopIcons MyComputer"
# 
IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Force

#####################
write-host "----------------HideMergeConflicts"
# 
IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -Value 0 -Force

#####################
write-host "-----------------DisableAutoplay"
# 
IF (!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force

##################### DeliveryOptimization
write-host "--------------DeliveryOptimization"
Get-Service -Name DoSvc | where {$_.status -eq 'running'} | Stop-Service -Force -ErrorAction SilentlyContinue -PassThru
Set-Service -Name DoSvc -StartupType Disable -ErrorAction SilentlyContinue
IF (!(Test-Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings))
{New-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Force}
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -Type String -Value 0 -Force
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\DoSvc -Name Start -PropertyType DWord -Value 4 -Force
# 0: WSUS only.
###########################################################################################################

######################
write-host "--------------------Create a Shortcut with Windows PowerShell"
$SourceFileLocation = "$env:SystemRoot\System32\msra.exe"
$ShortcutLocation = "$env:public\Desktop\Удаленный помощник.lnk"
#New-Object : Creates an instance of a Microsoft .NET Framework or COM object.
#-ComObject WScript.Shell: This creates an instance of the COM object that represents the WScript.Shell for invoke CreateShortCut
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
$Shortcut.TargetPath = $SourceFileLocation
#Save the Shortcut to the TargetPath
$Shortcut.Save()

# Display the recycle bin files delete confirmation dialog
$ShellState = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState
$ShellState[4] = 51
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState -PropertyType Binary -Value $ShellState -Force
##################### Disable MeetNow (Skype) 
New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name HideSCAMeetNow -PropertyType DWord -Value 1 -Force
##################### Disable News and Interests
IF (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds"))
{New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds" -Force}
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds" -Name EnableFeeds -PropertyType DWord -Value 0 -Force

##################### Num Lock при загрузке
IF (!(Test-Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard"))
{
	New-Item -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Force
}
New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -Type String -Value 2147483650 -Force

##################### Отключаем IPv6 на всех интерфейсах 
Get-NetAdapterBinding –InterfaceAlias “Ethernet”
Disable-NetAdapterBinding –InterfaceAlias “Ethernet” –ComponentID ms_tcpip6
##################### Enable Ping
#New-NetFirewallRule -DisplayName "Allow inbound ICMPv4 Ping" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow -Profile Any
Enable-NetFirewallRule -displayName "File and Printer Sharing (Echo Request - ICMPv4-In)"

################### Trying remove printers Fax and OneNote for Windows 10
write-host "--------------------Trying remove printers Fax and OneNote for Windows 10"
Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue
write-host "Remove-Printer Fax"
Remove-Printer -Name "OneNote for Windows 10" -ErrorAction SilentlyContinue
write-host "Remove-Printer OneNote for Windows 10"
Remove-Printer -Name "Microsoft XPS Document Writer" -ErrorAction SilentlyContinue
write-host "Microsoft XPS Document Writer"

#################### Google Chrome
IF (!(Test-Path "HKLM:\Software\Policies\Google\Chrome\RestoreOnStartupURLs"))
{New-Item -Path "HKLM:\Software\Policies\Google\Chrome\RestoreOnStartupURLs" -Force}
New-ItemProperty -Path "HKLM:\Software\Policies\Google\Chrome" -Name RestoreOnStartup -PropertyType DWord -Value 4 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Google\Chrome\RestoreOnStartupURLs" -Name 1 -PropertyType String -Value "site.kz" -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Google\Chrome" -Name BookmarkBarEnabled -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Google\Chrome" -Name AlwaysOpenPdfExternally -PropertyType DWord -Value 1 -Force
write-host "------------------Add site.kz InsecureContentAllowed Chrome"
IF (!(Test-Path "HKLM:\SOFTWARE\Policies\Google\Chrome\InsecureContentAllowedForUrls")) 
{New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\InsecureContentAllowedForUrls" -Force}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\InsecureContentAllowedForUrls" -Name 1 -Value "[*.]site.kz" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\InsecureContentAllowedForUrls" -Name 2 -Value "[*.]site2.kz" -Force

#################### Edge Chromium
IF (!(Test-Path "HKLM:\Software\Policies\Microsoft\Edge\RestoreOnStartupURLs"))
{New-Item -Path "HKLM:\Software\Policies\Microsoft\Edge\RestoreOnStartupURLs" -Force}
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name RestoreOnStartup -PropertyType DWord -Value 4 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge\RestoreOnStartupURLs" -Name 1 -PropertyType String -Value "site.kz" -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name FavoritesBarEnabled -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name AlwaysOpenPdfExternally -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name PersonalizationReportingEnabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name StartupBoostEnabled -PropertyType DWord -Value 0 -Force
write-host "------------------Add site.kz InsecureContentAllowed Edge"
IF (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\InsecureContentAllowedForUrls")) 
{New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\InsecureContentAllowedForUrls" -Force}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\InsecureContentAllowedForUrls" -Name 1 -Value "[*.]site.kz" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\InsecureContentAllowedForUrls" -Name 2 -Value "[*.]site2.kz" -Force

#############################################################
write-host "--------------------Honeyview regall"
Start-Process -FilePath "c:\Program Files\Honeyview\Honeyview.exe" -ArgumentList "/regall"
##############################

######################################################  For Windows 11
$OSver=[System.Environment]::OSVersion.Version.Build
If ($OSver -gt 22000)
{
	write-host "-----------------Windows 11 $OSver mini apps hide"
	IF (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"))
	{
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -PropertyType DWord -Value 0 -Force
		
	IF (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications"))
	{
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" -Force
		}
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" -Name ConfigureChatAutoInstall -PropertyType DWord -Value 0 -Force
			
	IF (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Chat"))
	{
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" -Force
		}
		New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" -Name ChatIcon -PropertyType DWord -Value 3 -Force
### Copilot Off
	IF (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"))
	{
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Force
		}
		New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name TurnOffWindowsCopilot -PropertyType DWord -Value 1 -Force

	IF (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy"))
	{
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy" -Force
		}
		New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy" -Name VerifiedAndReputablePolicyState -PropertyType DWord -Value 0 -Force

#write-host "-----------------Windows 11 SetUserFTA Fix need reboot"
#Start-Process -FilePath "\\ulbassdat\install\Reestr\win_tweak\sc\SetUserFTA\Fix_SetUserFTA.exe"
write-host "need PC reboot"
}
Start-Process explorer