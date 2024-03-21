# Bu PowerShell scripti, Active Directory'deki belirli bir Organizasyon Birimi'nde (OU) bulunan kullanıcıların belirli özelliklerini alır ve bu bilgileri bir CSV dosyasına yazma işlemini gerçekleştirir. İşleyiş adımları şu şekildedir:

# 1. İlk olarak, belirtilen OU'nun DistinguishedName'ini belirler.
# 2. Get-ADUser cmdlet'i kullanılarak belirtilen OU altındaki tüm kullanıcı bilgilerini alır.
# 3. Her bir kullanıcı için belirli özelliklerini içeren bir nesne oluşturur.
# 4. Oluşturulan nesneleri bir diziye ekler.
# 5. Son olarak, bu dizi içindeki kullanıcı bilgilerini bir CSV dosyasına yazarak işlemi tamamlar.

# Bu script, belirli bir OU altındaki kullanıcı bilgilerini hızlı ve etkili bir şekilde CSV formatında dışa aktarmak için kullanılabilir. Bu, kullanıcı bilgilerinin raporlanması veya başka sistemlere aktarılması gibi senaryolarda kullanışlı olabilir.

# Active Directory modülünü yükle
Import-Module ActiveDirectory

# Kullanıcı bilgilerini almak istediğiniz OU'nun DistinguishedName'ini belirtin
$ouDN = "OU=01.Maltepe_Kampusu,OU=01.Akademik_Personel,OU=01.Egitim,DC=acibadem,DC=edu,DC=tr"

# Kullanıcıları al
$users = Get-ADUser -Filter * -SearchBase $ouDN -Properties *

# CSV dosyasına yazmak için kullanıcı bilgilerini diziye dönüştür
$userData = @()
$totalUsers = $users.Count
$processedUsers = 0

foreach ($user in $users) {
    $processedUsers++
    $progressPercentage = ($processedUsers / $totalUsers) * 100
    Write-Progress -Activity "Kullanıcılar İşleniyor" -Status "İşlenen Kullanıcı: $processedUsers / $totalUsers" -PercentComplete $progressPercentage

    $userProperties = @{
        "SamAccountName" = $user.sAMAccountName
        "Name" = $user.Name
        "GivenName" = $user.GivenName
        "Surname" = $user.Surname
        "EmailAddress" = $user.EmailAddress
        "Title" = $user.Title
        "Department" = $user.Department
        "Office" = $user.Office
        "City" = $user.City
        "Country" = $user.Country
        "Enabled" = $user.Enabled
        "ipPhone" = $user.ipPhone
        "HomePhone" = $user.HomePhone
        "DistinguishedName" = $user.DistinguishedName
    }
    $userData += New-Object PSObject -Property $userProperties
}

# CSV dosyasına yaz
$userData | Export-Csv -Path "C:\Users\emir.yigit\Desktop\ActiveDirectory\14.02.2024\ogretimUyesiInfo.csv" -NoTypeInformation -Encoding utf8

Write-Progress -Activity "Kullanıcılar İşleniyor" -Completed
