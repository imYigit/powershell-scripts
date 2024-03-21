# Bu PowerShell scripti, belirtilen Organizasyon Birimi (OU) altındaki bilgisayarların durumunu kontrol etmek için kullanılır. Script, belirtilen bir hizmetin (servis) adını alır ve bu hizmetin belirtilen OU altındaki tüm bilgisayarlarda durumunu kontrol eder.

# İşleyiş şu adımları takip eder:

# 1. Yürütme politikasını RemoteSigned olarak ayarlar. Bu, betiklerin yalnızca yerel sistemde imzalanmış betiklerin otomatik olarak yürütülmesine izin verir.
# 2. Kontrol edilecek hizmetin adını ve kontrol edilecek Organizasyon Birimi'nin adını kullanıcıdan alır.
# 3. Bir log dosyası oluşturur ve bu dosyanın yolunu belirler.
# 4. Belirtilen Organizasyon Birimi altındaki tüm bilgisayarları alır.
# 5. Her bir bilgisayar için belirtilen hizmetin durumunu kontrol eder.
# 6. Bilgisayarın erişilebilirliğini kontrol eder ve gerekli mesajları oluşturarak log dosyasına yazar.

# Bu script, belirtilen OU altındaki bilgisayarların hizmet durumunu kontrol ederek bu bilgileri bir log dosyasına kaydedebilir. Bu, genellikle hizmet durumunu toplu olarak izlemek ve yönetmek için kullanılır.


# Yürütme politikasını ayarla
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Organizational Unit adını ve kontrol edilecek servisin adını belirtin
$serviceName = Read-Host "Kontrol Edilecek Servis Adı"
$organizationalUnit = Read-Host "Kontrol Edilecek Organization Unite"

# Log dosyasını oluştur
$logFilePath = "C:\Logs\Log.txt"
Write-Host "DEBUG: \$logFilePath tanımlandı: $logFilePath"

# Organizational Unit altındaki bilgisayarları al
$computers = Get-ADComputer -Filter * -SearchBase $organizationalUnit

# Her bilgisayar için servisin durumunu kontrol et
foreach ($computer in $computers) {
    $computerName = $computer.Name
    $serviceStatus = Get-Service -ComputerName $computerName -Name $serviceName -ErrorAction SilentlyContinue

    if (Test-Connection -ComputerName $computerName -Count 1 -Quiet) {

        if ($serviceStatus -eq $null) {
            $logMessage = "Servis bulunamadı: $computerName"
            Write-Host $logMessage
            Add-Content -Path $logFilePath -Value $logMessage
        } else {
            $logMessage = "Servis var: $computerName"
            Write-Host $logMessage
            Add-Content -Path $logFilePath -Value $logMessage
        }
    } else {
        $logMessage = "Erişim yok: $computerName"
        Write-Host $logMessage
        Add-Content -Path $logFilePath -Value $logMessage
    }
}
