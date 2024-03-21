# Bu PowerShell scripti, belirli bir grup ve bu grup altındaki üyelerin bilgilerini alarak bir CSV dosyasına yazma işlemini gerçekleştirir.

# İşleyiş şu adımları takip eder:

# 1. Active Directory modülünü yükler.
# 2. Belirli bir grupun DistinguishedName (DN) değerini belirtir.
# 3. Belirtilen DN değerine sahip gruba erişir ve grup üyelerini alır.
# 4. Grubun altındaki üyeleri döngüye alır ve her bir üyenin DN, kullanıcı adı ve tür bilgilerini içeren bir hashtable oluşturur.
# 5. Oluşturulan veriyi CSV formatına uygun hale getirir ve bir diziye ekler.
# 6. Son olarak, oluşturulan CSV verisini belirtilen yol ve isimde bir CSV dosyasına yazarak işlemi tamamlar.

# Bu betik, belirtilen bir grup ve bu grubun altındaki üyelerin bilgilerini CSV dosyasına aktarmak için kullanılabilir.

# İçeri aktar
Import-Module ActiveDirectory

# Grup DN değeri
$grupDN = "Grup DN değeri"

# Grubu al
$grup = Get-ADObject -Filter {DistinguishedName -eq $grupDN} -Properties member

if ($grup) {
    # Grubun alt üyelerini al
    $altUyeler = $grup.member | Get-ADObject
    
    # CSV dosyası için boş bir dizi oluştur
    $csvData = @()

    # Alt üyeleri dolaşarak bilgileri topla
    foreach ($uye in $altUyeler) {
        # CSV verisi için uygun formatı oluştur
        $csvSatir = New-Object PSObject -Property @{
            "DN" = $uye.DistinguishedName
            "Kullanıcı Adı" = $uye.name
            "Tür" = $uye.ObjectClass
            #...
        }

        # CSV verisini diziye ekle
        $csvData += $csvSatir
    }

    # CSV dosyasına yaz
    $csvData | Export-Csv -Path "C:\Exports\Export.csv" -Encoding UTF8 -NoTypeInformation

    Write-Host "Grup ve alt üyeleri CSV dosyasına başarıyla yazıldı."
} else {
    Write-Host "Belirtilen DN değerine sahip grup bulunamadı."
}
