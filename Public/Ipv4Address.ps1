 <#
.SYNOPSIS
    Test an IP address assigned on a local network IPv4Address.
.DESCRIPTION
    Test a local network IPv4Address and optionally and specific property.
.PARAMETER Target
    Specifies the name of the network adapter to search for.
.PARAMETER Property
    Specifies an optional property to test for on the adapter. 
.PARAMETER Should 
    A Script Block defining a Pester Assertion.
.EXAMPLE
    IPv4Address ethernet0 { should not BeNullOrEmpty }
.EXAMPLE
    IPv4Address ethernet0 Type { should be 'unicast' }
.EXAMPLE
    IPv4Address Ethernet0 AddressSpeed { should be 'Preferred' } 
.EXAMPLE
    IPv4Address Ethernet0 IPAddress { should be '192.168.1.1' }
.NOTES
    Assertions: Be, BeNullOrEmpty
#>
function IPv4Address {
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
   
    $expression = {Get-NetIPAddress -AddressFamily 'Ipv4' @Target -ErrorAction SilentlyContinue}

    $params = Get-PoshspecParam -TestName IPv4Address -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}
