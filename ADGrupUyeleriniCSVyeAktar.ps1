# Bu PowerShell scripti, Active Directory modülünü kullanarak belirli bir Organizasyon Birimi (OU) altındaki kullanıcıları ve bir gruba atanmış üyeleri alır. Daha sonra, bu grup üyelerini CSV dosyasına yazmak için kullanıcıların ilgili bilgilerini toplar.

# İşleyiş şu adımları takip eder:

# 1. Active Directory modülünü yükler.
# 2. OU ve grup yollarını tanımlar.
# 3. OU altındaki tüm kullanıcıları ve belirli bir gruptaki üyeleri alır.
# 4. CSV dosyasına yazmak için kullanılacak veri nesnelerini oluşturur.
# 5. Grup üyelerini listeleyerek, her bir kullanıcının OU altında olup olmadığını kontrol eder.
# 6. Kullanıcılar hakkında gerekli bilgileri toplar ve bu bilgileri CSV dosyasına yazar.
# 7. Son olarak, CSV dosyasının yoluyla bir mesaj görüntüler.

# Bu betik, belirli bir OU altındaki kullanıcıları ve belirli bir gruba atanmış üyeleri listelemek ve bu bilgileri bir CSV dosyasına aktarmak için kullanılabilir.

# Active Directory modülünü yükle
Import-Module ActiveDirectory

# OU ve grup bilgilerini tanımla
$ouPath = Read-Host "OU Dn Değeri"
$groupPath = Read-Host "Grup DN Değeri"

# OU altındaki kullanıcıları ve grup üyelerini al
$ouUsers = Get-ADUser -Filter * -SearchBase $ouPath -Properties EmailAddress, IPPhone, telephoneNumber

$groupMembers = Get-ADGroupMember -Identity $groupPath

# Grup üyelerini CSV dosyasına yazmak için kullanılacak olan nesneleri oluştur
$outputData = @()

# Grup üyelerini listeleyerek CSV dosyasına yaz
foreach ($member in $groupMembers) {
    # Eğer kullanıcı belirli bir OU altındaysa, CSV dosyasına ekleyerek bilgileri topla
    $ouUser = $ouUsers | Where-Object { $_.DistinguishedName -eq $member.DistinguishedName }
    if ($ouUser) {
        $userData = [PSCustomObject]@{
            "Kullanıcı Adı" = $ouUser.SamAccountName
            "Adı Soyadı" = $ouUser.Name
            "E-Posta" = $ouUser.EmailAddress
            "IP Telefon Numarası" = $ouUser.IPPhone
            "Telefon Numarası" = $ouUser.telephoneNumber
            # Diğer kullanıcı özelliklerini ekleyebilirsiniz
        }
        $outputData += $userData
    }
}

# CSV dosyasını oluştur
$csvFilePath = "C:\path\to\file\'$groupPath'.csv"
$outputData | Export-Csv -Path $csvFilePath -NoTypeInformation -Encoding UTF8

Write-Host "CSV dosyası oluşturuldu: $csvFilePath"

```
