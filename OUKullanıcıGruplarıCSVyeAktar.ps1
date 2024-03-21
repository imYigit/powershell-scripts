# Bu PowerShell scripti, belirli bir Organizational Unit'taki (OU) kullanıcıları çeker ve her bir kullanıcının üye olduğu grupları bir CSV dosyasına dışa aktarır. Kullanıcılar, kullanıcı adları (SamAccountName), isimleri (Name) ve üye oldukları gruplarla birlikte listelenir.

# Bu PowerShell scripti, belirli bir Organizasyon Birimi (OU) altındaki kullanıcıların üye olduğu grupları listeleyerek bu bilgileri bir CSV dosyasına aktarır.

# İşleyiş şu adımları takip eder:

# 1. Active Directory modülünü yükler.
# 2. Dışa aktarılacak OU'nun DistinguishedName'ini belirtir.
# 3. Belirtilen OU altındaki kullanıcıları alır ve bunların `SamAccountName`, `Name` ve `MemberOf` özelliklerini içeren bir nesne oluşturur.
# 4. Her bir kullanıcı için aşağıdaki adımları gerçekleştirir:
# a. Kullanıcının üye olduğu grupları alır.
# b. Kullanıcı verilerini bir hashtable'e ekler.
# c. Her bir grup için bir sütun oluşturarak, kullanıcının ilgili grup üyesi olup olmadığını belirler.
# d. Hashtable'i veri listesine ekler.
# 5. Elde edilen veriyi CSV dosyasına dışa aktarır.

# Bu betik, belirli bir OU altındaki kullanıcıların hangi gruplara üye olduklarını belirlemek ve bu bilgileri bir CSV dosyasına kaydetmek için kullanılabilir.

# Active Directory modülünü içe aktar
Import-Module ActiveDirectory

# Dışa aktarılacak OU'nun DistinguishedName'ini belirt
$ouDN = Read-Host "OU'nun DistinguishedName'ini belirt"

# Kullanıcıları içeren bir nesne oluştur
$users = Get-ADUser -Filter * -SearchBase $ouDN -Properties SamAccountName, Name, MemberOf

# Veri için boş bir hashtable oluştur
$data = @()

# Her bir kullanıcı için işlem yap
foreach ($user in $users) {
    # Kullanıcının üye olduğu grupları al
    $groups = $user.MemberOf | ForEach-Object { (Get-ADGroup $_).Name }

    # Kullanıcı verilerini hashtable'e ekle
    $userData = @{
        SamAccountName = $user.SamAccountName
        Name = $user.Name
    }

    # Her bir grup için sütun oluştur
    foreach ($group in $groups) {
        $userData[$group] = $true
    }

    # Hashtable'i veri listesine ekle
    $data += New-Object PSObject -Property $userData
}

# Veriyi CSV dosyasına dışa aktar
$data | Export-Csv -Path "C:\Exports\Export.csv" -NoTypeInfo

```
