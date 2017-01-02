<#
.SYNOPSIS
    Test a a Tcp Port.
.DESCRIPTION
    Test that a Tcp Port is listening and optionally validate any TestNetConnectionResult property.
.PARAMETER Target
    Specifies the Domain Name System (DNS) name or IP address of the target computer.
.PARAMETER Qualifier
    Specifies the TCP port number on the remote computer.
.PARAMETER Property
    Specifies a property of the TestNetConnectionResult object to test.  
.PARAMETER Should 
    A Script Block defining a Pester Assertion.  
.EXAMPLE
    TcpPort @{ComputerName='localhost';Port=80} PingSucceeded  { Should Be $true }
.EXAMPLE
    TcpPort @{ComputerName='localhost';Port=80} TcpTestSucceeded { Should Be $true }
.NOTES
    Assertions: Be, BeExactly, Match, MatchExactly
#>
function TcpPort {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [Object]$Target,
      
        [Parameter(Mandatory, Position=1)]
        [ValidateSet("AllNameResolutionResults", "BasicNameResolution", "ComputerName", "Detailed", "DNSOnlyRecords", "InterfaceAlias", 
            "InterfaceDescription", "InterfaceIndex", "IsAdmin", "LLMNRNetbiosRecords", "MatchingIPsecRules", "NameResolutionSucceeded", 
            "NetAdapter", "NetRoute", "NetworkIsolationContext", "PingReplyDetails", "PingSucceeded", "RemoteAddress", "RemotePort", 
            "SourceAddress", "TcpClientSocket", "TcpTestSucceeded", "TraceRoute")]
        [string]$Property,   
        
        [Parameter(Mandatory, Position=2)]
        [scriptblock]$Should
    )
    Switch -Exact (Get-TargetType -Target $Target) {
        'String' {
            Write-Error -Message "TcpPort- requires a hashtable input with ComputerName and Port"
            break;
        }
        'Hashtable' {
            $expression = {Test-NetConnection @Target -ErrorAction SilentlyContinue};
            break;
        }
    }
    
    $params = Get-PoshspecParam -TestName TcpPort -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}