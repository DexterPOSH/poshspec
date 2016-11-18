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
    TcpPort @{ComputerName=localhost;Port=80} PingSucceeded  { Should Be $true }
.EXAMPLE
    TcpPort @{ComputerName=localhost;Port=80} TcpTestSucceeded { Should Be $true }
.NOTES
    Assertions: Be, BeExactly, Match, MatchExactly
#>
function TcpPort {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=1)]
        [HashTable]$TargetHash,
      
        [Parameter(Mandatory, Position=2)]
        [ValidateSet("AllNameResolutionResults", "BasicNameResolution", "ComputerName", "Detailed", "DNSOnlyRecords", "InterfaceAlias", 
            "InterfaceDescription", "InterfaceIndex", "IsAdmin", "LLMNRNetbiosRecords", "MatchingIPsecRules", "NameResolutionSucceeded", 
            "NetAdapter", "NetRoute", "NetworkIsolationContext", "PingReplyDetails", "PingSucceeded", "RemoteAddress", "RemotePort", 
            "SourceAddress", "TcpClientSocket", "TcpTestSucceeded", "TraceRoute")]
        [string]$Property,   
        
        [Parameter(Mandatory, Position=3)]
        [scriptblock]$Should
    )

    $params = Get-PoshspecParam -TestName TcpPort -TestExpression {Test-NetConnection @TargetHash  -ErrorAction SilentlyContinue} @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}