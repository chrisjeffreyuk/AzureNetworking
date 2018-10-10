Login-AzureRmAccount
Get-AzureRmSubscription
Select-AzureRmSubscription -Subscriptionname "xxxx"

# Declare the vairables
$rgName = "demoRG"
$vnetName = "demoRG-vnet"
$nsgName = "demoNSG01"
$location = "EastUS2"
$sourcePort = "*"
$destinationPort = 80,22
$priority = "105"

# Create the Application Security Group
$asg1 = New-AzureRmApplicationSecurityGroup -ResourceGroupName $rgName -Name WebServers -Location $location

Get-AzureRmApplicationSecurityGroup

# Get the NSG resource
$resource = Get-AzureRmResource | Where {$_.ResourceGroupName –eq $rgName -and $_.ResourceType -eq "Microsoft.Network/networkSecurityGroups"} 
$nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName

# Create the Application Security Group Rule
Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName |
Add-AzureRmNetworkSecurityRuleConfig -Name WebServers -Description "Custom ASG Rule" -Access Allow `
    -Protocol "*" -Direction Inbound -Priority $priority -SourceApplicationSecurityGroup $asg1 -SourcePortRange $sourcePort `
    -DestinationApplicationSecurityGroup $asg1 -DestinationPortRange $destinationPort |
Set-AzureRmNetworkSecurityGroup

# Apply the Application Security Group to the virtual machine interfaces
$nic = Get-AzureRmNetworkInterface -Name demoVM01-NIC -ResourceGroupName $rgName
$nic.IpConfigurations[0].ApplicationSecurityGroups = $asg1
Set-AzureRmNetworkInterface -NetworkInterface $nic

$nic = Get-AzureRmNetworkInterface -Name demoVM02-NIC -ResourceGroupName $rgName
$nic.IpConfigurations[0].ApplicationSecurityGroups = $asg1
Set-AzureRmNetworkInterface -NetworkInterface $nic