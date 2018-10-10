Login-AzureRmAccount
Get-AzureRmSubscription
Select-AzureRmSubscription -Subscriptionname "xxxx"

# Declare the vairables
$rgName = "demoRG"
$source = "*"
$sourcePort = "*"
$destinationPort = "80"
$rulename = "Port_80_External_Allow"
$nsgName = "demoNSG01"
$priority = "101"
$sourceIP = "*"
$destinationIP = "10.0.10.12"

# Get the NSG resource
$resource = Get-AzureRmResource | Where {$_.ResourceGroupName –eq $rgName -and $_.ResourceType -eq "Microsoft.Network/networkSecurityGroups"} 
$nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName

# Add the inbound security rule.
$nsg | Add-AzureRmNetworkSecurityRuleConfig -Name $rulename -Description "Custom Rule" -Access Allow `
    -Protocol * -Direction Inbound -Priority $priority -SourceAddressPrefix $source -SourcePortRange $sourcePort `
    -DestinationAddressPrefix $destinationIP -DestinationPortRange $destinationPort

# Update the NSG.
$nsg | Set-AzureRmNetworkSecurityGroup