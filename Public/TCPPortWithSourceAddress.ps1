<#
.SYNOPSIS
    Tests a computername is reachable on the mentioned port via the NIC interface whose SourceIP is specified.
.DESCRIPTION
    Test that a Tcp Port is listening on a remote host and reachable via a specific NIC interface.
.PARAMETER TargetHash
    Specifies the hash table param to be passed to the underlying function Test-NetConnectionWithSourceAddress
.PARAMETER Should 
    A Script Block defining a Pester Assertion.  
.EXAMPLE
    TcpPortWithSourceAddress @{ComputerName='localhost';Port=80;SourceIP='10.1.1.1'}   { Should Be $true }
.EXAMPLE
    TcpPort @{ComputerName='localhost';Port=80;SourceIP='10.1.1.1'} { Should Be $false }
.NOTES
    Assertions: Be
#>
function TcpPortWithSourceAddress {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory, Position=0)]
        [Object]$Target,
        
        [Parameter(Mandatory, Position=1)]
        [scriptblock]$Should
    )

    Switch -Exact (Get-TargetType) {
        'String' {
            Write-Error -Message "TcpPortWithSourceAddress - requires a hashtable input with ComputerName, Port and SourceIP"
            break;
        }
        'Hashtable' {
            $expression = {Test-NetConnectionWithSourceAddress @Target -ErrorAction SilentlyContinue};
            break;
        }
    }
    $params = Get-PoshspecParam  -TestName TcpPortWithSourceAddress -TestExpression $Expression  @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}