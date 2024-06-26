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
