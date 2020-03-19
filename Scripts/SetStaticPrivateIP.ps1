#Sets the private IP as static to NIC object previously created

param(
    [Parameter(Mandatory=$true)]
    [string]
    $RG
)

$nics = Get-AzNetworkInterface -ResourceGroupName $RG

foreach ($nic in $nics){
    if ($nic.IpConfigurations[0].PrivateIpAllocationMethod -ne 'Static'){
        $nic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
        $nic | Set-AzNetworkInterface
    }
}
