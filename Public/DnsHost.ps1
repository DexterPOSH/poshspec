<#
.SYNOPSIS
    Test DNS resolution to a host.
.DESCRIPTION
    Test DNS resolution to a host.
.PARAMETER Target
    The hostname to resolve in DNS.
.PARAMETER Should 
    A Script Block defining a Pester Assertion.  
.EXAMPLE           
    dnshost @{Name='nonexistenthost.mymadeupdomain.tl';Server='2.2.2.2'}   { should be $null }        
.EXAMPLE
     dnshost @{Name='google.com';Server='192.168.1.1'} Name {Should BeLike  '*Google.com'}
.NOTES
    Assertions: be
#>
function DnsHost {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
        [Parameter(Mandatory, Position=0)]
        [Alias('Name')]
        [Object]$Target,
        
        [Parameter(Position=1, ParameterSetName='prop')]
        [string]$Property,

        [Parameter(Mandatory, Position=1, ParameterSetName='Default')]
        [Parameter(Mandatory, Position=2, ParameterSetName='prop')]
        [scriptblock]$Should
    )

    Switch -Exact (Get-TargetType -Target $Target) {
        'String' {
            $expression = {Resolve-DnsName -Name $Target -DnsOnly -NoHostsFile -ErrorAction SilentlyContinue};
            break;
        }
        'Hashtable' {
            $expression = {Resolve-DnsName @Target -DnsOnly -NoHostsFile -ErrorAction SilentlyContinue};
            break
        }
    }
    
    $params = Get-PoshspecParam -TestName DnsHost -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}