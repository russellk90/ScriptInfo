Import-Module VMware.PowerCLI

$vcenter_srv = "osihvc04"

$Lines = Get-Content C:\WebAccess\VMWARE\ListOfServers.txt
$vmNames = $Lines 


Write "Test1 - see if connecting to vcentre"
echo $vcenter_srv

Write "Test2 - functions search lookups"

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

Write "Test3 - write convert to Html file"

$report | ConvertTo-Html | Out-File C:\WebAccess\VMWARE\ReportTesting.html
ii C:\WebAccess\VMWARE\ReportTesting.html
 


