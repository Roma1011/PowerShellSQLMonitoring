$physicalRAMMemory=(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb

while($true)
{
    Write-Host "Monitoring ....."

    $sqlMemoryOcupied = get-process -Name sqlservr | 
        select name, @{Name = "Private Working Set"; Expression = { 
                $ProcessID = $_.ID; [math]::Round((gwmi Win32_PerfFormattedData_PerfProc_Process | 
                        ? {$_.IDprocess -eq $ProcessID }).WorkingSetPrivate / 1Gb, 0)}}

    if($sqlMemoryOcupied.'Private Working Set' -ge 1)
    {
    Write-Host "Work"
        if($sqlMemoryOcupied.'Private Working Set' / $physicalRAMMemory * 100 -ge 80)
        {
            [int]$time24 = Get-Date -Format HH
            if($time24 -eq 10)
            {
                Write-Host "It is not possible to restart the server because the calculations are running during this time interval 10:00 - 11:00"
            }
            else
            {
               $temp=get-process -Name sqlservr
                Write-Host "Start Killing Server"
                $temp.Kill()
                $temp.WaitForExit();
                Write-Host "Start Server"
                net start MSSQLSERVER
            }
           
        }
    }
    Start-Sleep -s 15
}

