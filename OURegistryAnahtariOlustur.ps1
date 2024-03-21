# Bu PowerShell scripti, belirtilen bir Organizasyon Birimi'nin (OU) altındaki bilgisayarların kayıt defterinde belirli bir anahtarı oluşturmasını veya düzenlemesini sağlar.

# İşleyiş şu adımları takip eder:

# 1. Belirtilen OU'nun DistinguishedName'ini tanımlar.
# 2. Registry anahtarının oluşturulacağı veya düzenleneceği yolu belirler.
# 3. Registry anahtarının adını, türünü ve değerini belirler.
# 4. Belirtilen OU içindeki tüm bilgisayarları alır.
# 5. Her bir bilgisayar üzerinde belirtilen registry anahtarını ayarlamak için Invoke-Command kullanarak uzak komut çalıştırır.

# Bu betik, belirtilen OU içindeki tüm bilgisayarların kayıt defterinde belirli bir anahtarı oluşturmasını veya düzenlemesini sağlar. Bu, genellikle belirli yapılandırma ayarlarını toplu olarak uygulamak için kullanılır.


# OU'nun DistinguishedName'ini belirtin
$ouDistinguishedName = Read-Host "OU'nun DistinguishedName'ini belirtin"

# Registry anahtarını oluşturun veya düzenleyin
$registryPath = "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System"
$registryName = "SoftwareSASGeneration"
$registryType = "DWord"
$registryValue = 3

# OU içindeki bilgisayarları alın
$computers = Get-ADComputer -Filter * -SearchBase $ouDistinguishedName

# Her bir bilgisayar üzerinde registry anahtarını ayarlayın
foreach ($computer in $computers) {
    $computerName = $computer.Name
    $remoteComputer = $computerName + "." + $env:USERDNSDOMAIN

    Invoke-Command -ComputerName $remoteComputer -ScriptBlock {
        param($path, $name, $type, $value)
        Set-ItemProperty -Path $path -Name $name -Value $value -Type $type -Force
    } -ArgumentList $registryPath, $registryName, $registryType, $registryValue
}
