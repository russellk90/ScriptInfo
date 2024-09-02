
#Start-Process powershell -file "C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"

Connect-VIServer osihvc04

$vcenter_srv = "osihvc04"
Write "Connected to Vcentre"  echo $vcenter_srv

Write "Gather generated server list"
$Lines = Get-Content C:\WebAccess\VMWARE\ServersList.txt

$vmNames = $Lines 

Write "Performing Search"

$report = foreach($vm in (Get-View -ViewType VirtualMachine -Filter @{'Name' = "$($vmNames -join '|')"})){

    foreach($ctrl in ($vm.Config.Hardware.Device | where{$_ -is [VMware.Vim.VirtualScsiController]})){

        foreach($disk in ($vm.Config.Hardware.Device | where{$_ -is [VMware.Vim.VirtualDisk] -and $_.ControllerKey -eq $ctrl.Key})){

            $obj = [ordered]@{

                VName = $vm.Config.Name

                SCSIController = $ctrl.DeviceInfo.Label

                DiskName = $disk.DeviceInfo.Label 

                SCSI_Id = "$($ctrl.BusNumber) : $($disk.UnitNumber)" 

                DiskFile = $disk.Backing.FileName 

                DiskSize = $disk.CapacityInKB * 1KB / 1GB 

                VCPU = $vm.Config.Hardware.NumCPU 

                VMemory = $vm.Config.Hardware.MemoryMB 
           
            }

            New-Object PSObject -Property $obj

        }

    }


}

$report | ConvertTo-Html | Out-File c:\WebAccess\VMWARE\StatsReport.html
Write "File Generated on osihserversus02" 



