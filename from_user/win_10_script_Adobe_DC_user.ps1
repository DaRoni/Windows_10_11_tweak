################### Назначаем просмотрщиком по умолчанию
write-host "----Adobe Acrobat Reader DC Default PDF Viewer"
#\\ulbassdat\install\Reestr\win_tweak\sc\SetUserFTA\SetUserFTA.exe .pdf AcroExch.Document.DC
#\\ulbassdat\install\Reestr\win_tweak\sc\SetUserFTA\SetUserFTA.exe .pdf Acrobat.Document.DC
\\ulbassdat\install\Reestr\win_tweak\sc\SetUserFTA\SetUserFTA.exe .pdf AcroExch.Document.2020
################### Запомнить текущее состояние панели инструментов
################### скрываем боковые панели справа
function AdobeBodyUser
{
IF (!(Test-Path $PathAdobeDC1))
{New-Item -Path $PathAdobeDC1 -Force}
################### Запомнить текущее состояние панели инструментов
################### скрываем боковые панели справа
write-host "----Remember Task Pane state after document closed"
IF (!(Test-Path $PathAdobeDC1+"\AVGeneral"))
{New-Item -Path $PathAdobeDC1+"\AVGeneral" -Force}
New-ItemProperty -Path $PathAdobeDC1+"\AVGeneral" -Name bRHPSticky -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path $PathAdobeDC1+"\AVGeneral" -Name aDefaultRHPViewMode_L -PropertyType String -Value "Collapsed" -Force
New-ItemProperty -Path $PathAdobeDC1+"\AVGeneral" -Name bExpandRHPInViewer -PropertyType DWord -Value 0 -Force
###################
IF (!(Test-Path $PathAdobeDC1+"\AdobeViewer"))
{New-Item -Path $PathAdobeDC1+"\AdobeViewer" -Force}
New-ItemProperty -Path $PathAdobeDC1+"\AdobeViewer" -Name EULA -PropertyType DWord -Value 1 -Force
}	

######################################## Adobe Acrobat (Continuous)
$PathAdobeDC1="HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC"
AdobeBodyUser
######################################## Adobe Reader DC
$PathAdobeDC1="HKCU:\SOFTWARE\Adobe\Acrobat Reader\DC"
AdobeBodyUser
######################################## Adobe Reader Classic 2020
$PathAdobeDC1="HKCU:\SOFTWARE\Adobe\Acrobat Reader\2020"
AdobeBodyUser
