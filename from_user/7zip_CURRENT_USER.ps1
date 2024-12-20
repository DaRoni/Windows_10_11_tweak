write-host "7zip association with 7z,zip,rar started"

IF (!(Test-Path HKCU:\Software\Classes\.7z))
{New-Item -Path HKCU:\Software\Classes\.7z -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\.7z  -Name "(Default)" -Value 7-Zip.7z -Force

IF (!(Test-Path HKCU:\Software\Classes\.rar))
{New-Item -Path HKCU:\Software\Classes\.rar -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\.rar  -Name "(Default)" -Value 7-Zip.rar -Force

IF (!(Test-Path HKCU:\Software\Classes\.zip))
{New-Item -Path HKCU:\Software\Classes\.zip -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\.zip  -Name "(Default)" -Value 7-Zip.zip -Force

write-host "7z"
IF (!(Test-Path HKCU:\Software\Classes\7-Zip.7z\DefaultIcon))
{New-Item -Path HKCU:\Software\Classes\7-Zip.7z\DefaultIcon -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.7z  -Name "(Default)" -Value "7z Archive" -Force
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.7z\DefaultIcon  -Name "(Default)" -Value "C:\Program Files\7-Zip\7z.dll,0" -Force

IF (!(Test-Path HKCU:\Software\Classes\7-Zip.7z\shell\open\command))
{New-Item -Path HKCU:\Software\Classes\7-Zip.7z\shell\open\command -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.7z\shell\open\command  -Name "(Default)" -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -Force

write-host "RAR"
IF (!(Test-Path HKCU:\Software\Classes\7-Zip.rar\DefaultIcon))
{New-Item -Path HKCU:\Software\Classes\7-Zip.rar\DefaultIcon -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.rar  -Name "(Default)" -Value "rar Archive" -Force
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.rar\DefaultIcon  -Name "(Default)" -Value "C:\Program Files\7-Zip\7z.dll,3" -Force

IF (!(Test-Path HKCU:\Software\Classes\7-Zip.rar\shell\open\command))
{New-Item -Path HKCU:\Software\Classes\7-Zip.rar\shell\open\command -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.rar\shell\open\command  -Name "(Default)" -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -Force

write-host "Zip"
IF (!(Test-Path HKCU:\Software\Classes\7-Zip.zip\DefaultIcon))
{New-Item -Path HKCU:\Software\Classes\7-Zip.zip\DefaultIcon -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.zip  -Name "(Default)" -Value "zip Archive" -Force
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.zip\DefaultIcon  -Name "(Default)" -Value "C:\Program Files\7-Zip\7z.dll,1" -Force

IF (!(Test-Path HKCU:\Software\Classes\7-Zip.zip\shell\open\command))
{New-Item -Path HKCU:\Software\Classes\7-Zip.zip\shell\open\command -Force}
Set-ItemProperty -Path HKCU:\Software\Classes\7-Zip.zip\shell\open\command  -Name "(Default)" -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -Force