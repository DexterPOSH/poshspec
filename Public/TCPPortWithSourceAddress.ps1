<#
.SYNOPSIS
    Tests a Tcp Port with source address.
.DESCRIPTION
    Test that a Tcp Port is listening and optionally validate any TestNetConnectionResult property, lets you specify the Source address for the connection.
.PARAMETER TargetHash
    Specifies the hash table param to be passed to the underlying function Test-NetConnectionWithSourceAddress
.PARAMETER Should 
    A Script Block defining a Pester Assertion.  
.EXAMPLE
    TcpPortWithSourceAddress @{ComputerName=localhost;Port=80;SourceIP='10.1.1.1'}   { Should Be $true }
.EXAMPLE
    TcpPort @{ComputerName=localhost;Port=80;SourceIP='10.1.1.1'} { Should Be $false }
.NOTES
    Assertions: Be
#>
function TcpPortWithSourceAddress {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory, Position=1)]
        [HashTable]$TargetHash,
        
        [Parameter(Mandatory, Position=2)]
        [scriptblock]$Should

    )
    $Expression = {Test-NetConnectionWithSourceAddress @TargetHash -ErrorAction SilentlyContinue}
    $params = Get-PoshspecParam  -TestName TcpPortWithSourceAddress -TestExpression $Expression  @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}