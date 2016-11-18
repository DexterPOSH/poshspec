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
    VMNetworkAdapter @{VMName='TestVM'} { should not BeNullOrEmpty }
.EXAMPLE
    VMNetworkAdapter @{VMName='TestVM'} SwitchName { should be 'External' }
.EXAMPLE
    VMNetworkAdapter @{VMName='TestVM'} Name { should be 'Management' } 
.NOTES
    Assertions: Be, BeNullOrEmpty
#>
function VMNetworkAdapter {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
        [Parameter(Mandatory, Position=1,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=1,ParameterSetName="Property")]
        [HashTable]$TargetHash,
        
        [Parameter(Position=2,ParameterSetName="Property")]
        [string]$Property,
        
        [Parameter(Mandatory, Position=2,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=3,ParameterSetName="Property")]
        [scriptblock]$Should
    )
    $null = $PSBoundParameters.Remove('Should')
    $PSbounParameters.Add('Should',[scriptblock]::Create($(& $should)))
    $expression = {Get-VMNetworkAdapter @targetHash  -ErrorAction SilentlyContinue}
    $params = Get-PoshspecParam -TestName VMNetworkAdapter -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}
