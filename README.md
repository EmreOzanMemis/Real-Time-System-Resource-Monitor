# Real-Time-System-Resource-Monitor
```
while($true)
{

    $ComputerCPU = (Get-WmiObject  -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average

    $ComputerMemory = Get-WmiObject  -Class win32_operatingsystem -ErrorAction Stop
    $UsedMemory = $ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory
    $Memory = (($UsedMemory/ $ComputerMemory.TotalVisibleMemorySize)*100)
    $RoundMemory = [math]::Round($Memory, 2)
	
	#$disk = Get-PSDrive C | Select-Object Used,Free 
	
	$TotalDisk = Get-WMIObject Win32_LogicalDisk -Filter "DeviceID='C:'"  | ForEach-Object {[math]::truncate($_.Size / 1GB)}
	$FreeSpace = Get-WMIObject Win32_LogicalDisk -Filter "DeviceID='C:'"  | ForEach-Object {[math]::truncate($_.freespace / 1GB)}

    $Date = Get-Date -DisplayHint Date -Format MM/dd/yyyy

    $Time = Get-Date -DisplayHint Time -Format HH:mm:ss

    Write-Host "Date: " $Date " Time: " $Time " CPU: " $ComputerCPU " Memory: " $RoundMemory " Free Space: " $Freespace " Total Size : " $TotalDisk
    
    sleep 2
}
```
Bu PowerShell scripti, belirli bir zaman aralığında bilgisayarın sistem kaynaklarını (CPU, bellek ve disk durumu) sürekli olarak izlemek için kullanılır. Aşağıda scriptin detaylı açıklaması ve neden kullanılabileceği hakkında bilgiler verilmiştir:

Script Açıklaması

  Sonsuz Döngü (while($true)):
        Bu, scriptin sonsuz bir döngü içinde çalışmasını sağlar. Döngü içinde belirtilen kod, durdurulana kadar sürekli olarak tekrar eder.

  CPU Yükü ($ComputerCPU):
        `Get-WmiObject -Class win32_processor` komutu, bilgisayarın işlemcisi hakkında bilgi toplar.
        Bu komutun sonucu, işlemcinin yüzde olarak ne kadar kullanıldığını gösteren LoadPercentage özelliği ile Measure-Object ve Select-Object kullanılarak ortalama CPU yükü hesaplanır.

  Bellek Kullanımı ($RoundMemory):
        `Get-WmiObject -Class win32_operatingsystem` komutu, bilgisayarın işletim sistemi hakkında bilgi sağlar.
        Bu bilgilerden, toplam bellek (TotalVisibleMemorySize) ve kullanılmayan bellek (FreePhysicalMemory) alınır.
        UsedMemory değişkeni, kullanılan fiziksel belleği temsil eder.
        Belleğin kullanım yüzdesi, UsedMemory'nin toplam bellek miktarına oranı alınarak hesaplanır.
        Bu değer iki ondalık basamağa yuvarlanır.

  Disk Kullanımı (C:\ Sürücüsü):
        `Get-WMIObject Win32_LogicalDisk -Filter "DeviceID='C:'"` komutu, C: sürücüsünün toplam kapasitesini (Size) ve kullanılmayan kapasitesini (freespace) getirir.
        Her iki değer de gigabayt cinsine çevrilir ve sayısal olarak alınır.

  Tarih ve Saat:
        `Get-Date komutu` kullanılarak mevcut tarih ve saat formatlanarak alınır.
        Tarih ve saat, `MM/dd/yyyy` ve `HH:mm:ss` formatında gösterilir.

Disk ve Network Driver Resoruce Monitor scriptinde aşağıdaki bölümde eklenmiştir.
 ```     
 # Disk sürücü ölçümleri
 $DiskReadBytesPerSec = Get-Counter '\PhysicalDisk(_Total)\Disk Read Bytes/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
 $DiskWriteBytesPerSec = Get-Counter '\PhysicalDisk(_Total)\Disk Write Bytes/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

 # Network sürücü ölçümleri
 $BytesReceivedPerSec = Get-Counter '\Network Interface(*)\Bytes Received/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
 $BytesSentPerSec = Get-Counter '\Network Interface(*)\Bytes Sent/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
```

  Bilgilerin Konsola Yazdırılması:
        `Write-Host` komutu, yukarıda toplanan tüm bilgileri bir satır olarak ekrana yazar.
        Bu satırda tarih, saat, CPU yükü, bellek kullanımı, C: sürücüsünün boş ve toplam kapasitesi gösterilir.

  Bekleme Süresi (sleep 2):
        `sleep 2`, scriptin her döngü arasında 2 saniye beklemesini sağlar. Bu, kaynak izleme verilerini sürekli güncellemeye izin verirken sistem üzerinde gereksiz yük oluşturmamak içindir.

Neden Kullanılır?

  Sistem Yönetimi: Sistem yöneticileri ve IT profesyonelleri, bu script ile bilgisayarın kaynak kullanımını anlık olarak izleyebilir. Bu, performans sorunlarının veya anormal kaynak tüketiminin tespiti için önemlidir.

  Otomatik İzleme: Script, sürekli olarak çalışarak belirli bir zaman aralığında (2 saniyede bir) sistem kaynaklarını izler. Bu, uzun süreli sistem izlemeleri ve raporlamalar için kullanılabilir.

  Sorun Tespiti ve Teşhis: Anormal CPU veya bellek kullanımı gibi sorunların teşhis edilmesine yardımcı olur.

  Geliştirme ve Optimizasyon: Sistem optimizasyonu veya geliştirme çalışmalarında, kaynak kullanımını izleyerek yapılacak geliştirmelerin etkisini gözlemleme imkânı sağlar.  


        
