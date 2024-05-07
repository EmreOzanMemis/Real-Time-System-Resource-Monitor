while ($true) {
    # Disk sürücü ölçümleri
    $DiskReadBytesPerSec = Get-Counter '\PhysicalDisk(_Total)\Disk Read Bytes/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    $DiskWriteBytesPerSec = Get-Counter '\PhysicalDisk(_Total)\Disk Write Bytes/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

    # Network sürücü ölçümleri
    $BytesReceivedPerSec = Get-Counter '\Network Interface(*)\Bytes Received/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    $BytesSentPerSec = Get-Counter '\Network Interface(*)\Bytes Sent/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

    # CPU ve RAM ölçümleri
    $ComputerCPU = (Get-WmiObject -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average

    $ComputerMemory = Get-WmiObject -Class win32_operatingsystem -ErrorAction Stop
    $UsedMemory = $ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory
    $Memory = (($UsedMemory / $ComputerMemory.TotalVisibleMemorySize) * 100)
    $RoundMemory = [math]::Round($Memory, 2)

    # Zaman bilgisi
    $Date = Get-Date -DisplayHint Date -Format MM/dd/yyyy
    $Time = Get-Date -DisplayHint Time -Format HH:mm:ss

    # Sonuçların gösterilmesi
    Write-Host "Date: $Date Time: $Time CPU: $ComputerCPU Memory: $RoundMemory DiskReadBytes/sec: $DiskReadBytesPerSec DiskWriteBytes/sec: $DiskWriteBytesPerSec BytesReceived/sec: $BytesReceivedPerSec BytesSent/sec: $BytesSentPerSec"

    # 2 saniye bekle
    Start-Sleep -Seconds 2
}
