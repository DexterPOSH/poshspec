 <#
.SYNOPSIS
    Test a VM's network adapter VLAN on the Compute host.
.DESCRIPTION
    Test a VM's network adapter on the Compute host.
.PARAMETER Target
    Specifies the hashtable with the VMname and optional Adapter Name. Splatted to Get-VMNetworkAdapter.
.PARAMETER Property
    Specifies an optional property to test for on the VM network adapter. 
.PARAMETER Should 
    A Script Block defining a Pester Assertion.
.EXAMPLE
    VMNetworkAdapterVLAN @{VMName='TestVM';VMNetworkAdapterName='Management'} { should not BeNullOrEmpty }
.EXAMPLE
    VMNetworkAdapterVLAN @{VMName='TestVM';VMNetworkAdapterName='Management'} Mode { should be 'Untagged' }
.EXAMPLE
    VMNetworkAdapterVLAN @{VMName='TestVM';VMNetworkAdapterName='Management'} AccessVlanID { should be 51 }
.NOTES
    Assertions: Be, BeNullOrEmpty
#>
function VMNetworkAdapterVLAN {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
        [Parameter(Mandatory, Position=1,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=1,ParameterSetName="Property")]
        [HashTable]$Target,
        
        [Parameter(Position=2,ParameterSetName="Property")]
        [string]$Property,
        
        [Parameter(Mandatory, Position=2,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=3,ParameterSetName="Property")]
        [scriptblock]$Should
    )
    $expression = {Get-VMNetworkAdapterVLAN @target  -ErrorAction SilentlyContinue}
    $params = Get-PoshspecParam -TestName VMNetworkAdapterVLAN -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}
