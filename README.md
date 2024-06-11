
# PowerShellSQLMonitoring


SQL Server Memory Monitor and Restart Script
This PowerShell script monitors the memory usage of the SQL Server process (sqlservr) and automatically restarts the SQL Server service if the memory usage exceeds a specified threshold. Specifically, the script checks if the memory usage exceeds 80% of the total physical RAM available on the system. If the threshold is exceeded, the script kills the SQL Server process and restarts the SQL Server service.

## Script Description

Prerequisites
This script requires administrative privileges to start and stop the SQL Server service.
PowerShell must be installed on the system where this script will be executed.


### Get Physical RAM Memory:

The script starts by calculating the total physical RAM available on the system. This is done using the Get-CimInstance cmdlet to query the Win32_PhysicalMemory class and summing up the capacity property of all physical memory modules.
$physicalRAMMemory = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb


### Continuous Monitoring Loop:

The script enters an infinite while loop to continuously monitor the SQL Server memory usage.

### Fetch SQL Server Memory Usage:

Inside the loop, the script retrieves the memory usage of the sqlservr process using the get-process cmdlet and the Win32_PerfFormattedData_PerfProc_Process WMI class.

> $sqlMemoryOcupied = get-process -Name sqlservr | 
    select name, @{Name = "Private Working Set"; Expression = { 
            $ProcessID = $_.ID; [math]::Round((gwmi Win32_PerfFormattedData_PerfProc_Process | 
                    ? {$_.IDprocess -eq $ProcessID }).WorkingSetPrivate / 1Gb, 0)}}


Check Memory Usage Against Threshold:

The script checks if the SQL Server memory usage exceeds 80% of the total physical RAM.

Restart SQL Server Process

Sleep Interval
