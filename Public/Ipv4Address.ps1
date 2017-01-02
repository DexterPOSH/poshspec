 <#
.SYNOPSIS
    Test an IP address assigned on a network interface.
.DESCRIPTION
    Test IPv4Address and optionally any specific property on the MSFT_NetIPAddress CIM class object.
.PARAMETER Target
    Specifies the interface alias of the network adapter to search for.
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
        [Parameter(Mandatory, Position=0,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=0,ParameterSetName="Property")]
        [Object]$Target,
        
        [Parameter(Position=1,ParameterSetName="Property")]
        [ValidateSet('ifIndex','Address','AddressOrigin','AddressType','AvailableRequestedStates','Caption','CommunicationStatus',
        'CreationClassName','Description','DetailedStatus','ElementName','EnabledDefault','EnabledState','HealthState','InstallDate',
        'InstanceID','InterfaceAlias','InterfaceIndex','IPAddress','IPv4Address','IPv6Address','IPVersionSupport','Name','NameFormat',
        'OperatingStatus','OperationalStatus','OtherEnabledState','OtherTypeDescription','PreferredLifetime','PrefixLength','PrimaryStatus',
        'ProtocolIFType','ProtocolType','PSComputerName','RequestedState','SkipAsSource','Status','StatusDescriptions','SubnetMask',
        'SystemCreationClassName','SystemName','TimeOfLastStateChange','TransitioningToState','ValidLifetime','AddressFamily','AddressState',
        'PrefixOrigin','Store','SuffixOrigin','Type')]
        [string]$Property,
        
        [Parameter(Mandatory, Position=1,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=2,ParameterSetName="Property")]
        [scriptblock]$Should
    )
    Switch -Exact (Get-TargetType -Target $Target) {
        'String' {
            $expression = {Get-NetIPAddress -AddressFamily 'Ipv4' -InterfaceAlias $Target -ErrorAction SilentlyContinue};
            break;
        }
        'Hashtable' {
            $expression = {Get-NetIPAddress -AddressFamily 'Ipv4' @Target -ErrorAction SilentlyContinue};
            break;
        }
    }
    
    #$expression = {Get-NetIPAddress -AddressFamily 'Ipv4' @Target -ErrorAction SilentlyContinue}

    $params = Get-PoshspecParam -TestName IPv4Address -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}
