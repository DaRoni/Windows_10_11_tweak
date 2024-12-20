# Региональные настройки
Set-Culture ru-RU
Set-WinSystemLocale -SystemLocale ru-RU
Set-WinUILanguageOverride -Language ru-RU
Set-WinHomeLocation -GeoId 0x89
#0xcb	203 Russia
#0x89	137 Kazakhstan
$list = New-WinUserLanguageList -Language "ru-RU"
$list.Add("en-US")
Set-WinUserLanguageList $list -Force
Write-Host "Now, System locale ru-RU"
Set-TimeZone -Id "Ekaterinburg Standard Time" -PassThru