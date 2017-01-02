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
    Usage with passing VM name only
    VMNetworkAdapterVLAN 'TestVM' { should not BeNullOrEmpty }
.EXAMPLE
    Usage with passing VM name only, it assumes the VM only has one network adapter 
    VMNetworkAdapterVLAN 'TestVM' Mode { should be 'Untagged' }
.EXAMPLE
    Specify the VMName and the network adapter name explicitly using the hashtable format for input
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
        [Parameter(Mandatory, Position=0,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=0,ParameterSetName="Property")]
        [Object]$Target,
        
        [Parameter(Position=1,ParameterSetName="Property")]
        [string]$Property,
        
        [Parameter(Mandatory, Position=1,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=2,ParameterSetName="Property")]
        [scriptblock]$Should
    )
    Switch -Exact (Get-TargetType -Target $Target) {
        'String' {
            $expression = {Get-VMNetworkAdapterVLAN -VMName $Target -ErrorAction SilentlyContinue};
            break;
        }
        'Hashtable' {
            $expression = {Get-VMNetworkAdapter @Target -ErrorAction SilentlyContinue};
            break;
        }
    }
    $params = Get-PoshspecParam -TestName VMNetworkAdapterVLAN -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}
