 <#
.SYNOPSIS
    Test a VM's network adapter on the Compute host.
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
    VMNetworkAdapter 'TestVM' { should not BeNullOrEmpty }
.EXAMPLE
    Usage with passing VM name only, it assumes the VM only has one network adapter 
    VMNetworkAdapterVLAN 'TestVM' SwitchName { should be 'Untagged' }
.EXAMPLE
    VMNetworkAdapter @{VMName='TestVM';Name='Management'} { should not BeNullOrEmpty }
.EXAMPLE
    VMNetworkAdapter @{VMName='TestVM'} SwitchName { should be 'External' }
.EXAMPLE
    VMNetworkAdapter @{VMName='TestVM'} Name { should be 'Management' }
.EXAMPLE
    VMNetworkAdapter @{Name='Management';ManagmentOS=$True}  { should NOT BeNullOrEmpty} 
.NOTES
    Assertions: Be, BeNullOrEmpty
#>
function VMNetworkAdapter {
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
            $expression = {Get-VMNetworkAdapter -VMName $Target -ErrorAction SilentlyContinue};
            break;
        }
        'Hashtable' {
            $expression = {Get-VMNetworkAdapter @Target -ErrorAction SilentlyContinue};
            break;
        }
    }
    $expression = {Get-VMNetworkAdapter @targetHash  -ErrorAction SilentlyContinue}
    $params = Get-PoshspecParam -TestName VMNetworkAdapter -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}
