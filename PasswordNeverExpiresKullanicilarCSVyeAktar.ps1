# Bu PowerShell scripti, Active Directory modülünü kullanarak "Password Never Expires" (Şifre Hiçbir Zaman Süresi Dolmaz) özelliği etkinleştirilmiş kullanıcıları alır ve bu kullanıcıların adını ve SamAccountName'ini içeren bir CSV dosyasına yazma işlemini gerçekleştirir.

# İşleyiş şu adımları takip eder:

# 1. Active Directory modülünü yükler.
# 2. CSV dosyasının yolunu belirler.
# 3. "Password Never Expires" özelliği etkinleştirilmiş tüm kullanıcıları alır ve bunların adını ve SamAccountName'ini içeren bir nesne oluşturur.
# 4. Bu bilgileri CSV dosyasına yazarak işlemi tamamlar.

# Bu betik, belirtilen özelliğin etkinleştirilmiş olduğu kullanıcıları bulmak ve bu kullanıcıların bilgilerini bir CSV dosyasına aktarmak için kullanılabilir.

# Active Directory modülünü yükle
Import-Module ActiveDirectory

# CSV dosyasının yolunu belirtin
$csvFilePath = "C:\Exports\Export.csv"

# "Password Never Expires" özelliği etkinleştirilmiş kullanıcıları al
$users = Get-ADUser -Filter {PasswordNeverExpires -eq $true} | Select-Object Name, SamAccountName

# CSV dosyasına yaz
$users | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "İşlem tamamlandı. CSV dosyası: $csvFilePath"
