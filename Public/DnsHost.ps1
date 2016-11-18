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
    dnshost @{Name=nonexistenthost.mymadeupdomain.tl;Server='2.2.2.2'}   { should be $null }        
.EXAMPLE
    dnshost  @{Name='google.com'} Name { should not be 'google.com' }
.NOTES
    Assertions: be
#>
function DnsHost {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=1)]
        [Alias('Name')]
        [HashTable]$TargetHash,
        
        
        [Parameter(Mandatory, Position=2, ParameterSetName='Default')]
        [scriptblock]$Should
    )
    $expression = {Resolve-DnsName @TargetHash -DnsOnly -NoHostsFile -ErrorAction SilentlyContinue}
    $params = Get-PoshspecParam -TestName DnsHost -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}