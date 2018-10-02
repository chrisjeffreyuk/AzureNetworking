Login-AzureRmAccount
Get-AzureRmSubscription
Set-AzureRmContext -SubscriptionId "xxxx"

# Declare the vairables
$rgName = "demoRG"
$source = "*"
$sourcePort = "*"
$destinationPort = "80"
$rulename = "Custom_Allow_Port_80"
$nsgName = "demoNSG01"
$priority = "105"
$sourceIP = "*"
$destinationIP = "10.1.0.12"

# Get the NSG resource
$resource = Get-AzureRmResource | Where {$_.ResourceGroupName –eq $rgName -and $_.ResourceType -eq "Microsoft.Network/networkSecurityGroups"} 
$nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName

# Add the inbound security rule.
$nsg | Add-AzureRmNetworkSecurityRuleConfig -Name $rulename -Description "Allow Port" -Access Allow `
    -Protocol * -Direction Inbound -Priority $priority -SourceAddressPrefix $source -SourcePortRange $sourcePort `
    -DestinationAddressPrefix $destinationIP -DestinationPortRange $destinationPort

# Update the NSG.
$nsg | Set-AzureRmNetworkSecurityGroup