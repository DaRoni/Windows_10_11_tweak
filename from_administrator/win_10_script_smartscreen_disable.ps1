write-host "------------------Exclude ulba.kz from Edge SmartScreen"
IF (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\SmartScreenAllowListDomains")) 
{New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\SmartScreenAllowListDomains" -Force}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\SmartScreenAllowListDomains" -Name 1 -Value "ulba.kz" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\SmartScreenAllowListDomains" -Name 2 -Value "kazatomprom.kz" -Force
IF (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended")) 
{New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended" -Force}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended" -Name SmartScreenDnsRequestsEnabled -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended" -Name SmartScreenEnabled -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name IntranetFileLinksEnabled -Value 1 -Force

write-host "------------------Disable System SmartScreen "
IF (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System")) 
{New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name EnableSmartScreen -Value 0 -Force