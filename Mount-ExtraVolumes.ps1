#ps1
function Mount-ExtraVolumes {
    # Usage:       Mount-ExtraVolumes
    # Description: Onlines and mount any offline volumes
    #
    $off_disks = Get-Disk | Where-Object -Property OperationalStatus -eq Offline
    $off_disks | Set-Disk -IsOffline $False
    $off_disks | Set-Disk -IsReadOnly $False
}
