# Disable Windows animation on Windows 10, Win+U 
write-host "Disable Windows animation on Windows 10, Win+U"
IF (!(Test-Path "HKCU:\Control Panel\Desktop\WindowMetrics"))
{
	New-Item -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Force
	}
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0 -Force
	IF (!(Test-Path "HKCU:\Control Panel\Desktop"))
	{
		New-Item -Path "HKCU:\Control Panel\Desktop" -Force
		}
		write-host "Trying change UserPreferencesMask"
		New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -PropertyType Binary -Value ([byte[]](0x90,0x12,0x07,0x80,0x10,0x00,0x00,0x00)) -Force
		

#"UserPreferencesMask"=hex:90,12,07,80,10,00,00,00