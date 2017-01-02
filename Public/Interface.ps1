 <#
.SYNOPSIS
    Test a local network interface.
.DESCRIPTION
    Test a local network interface and optionally and specific property.
.PARAMETER Target
    Specifies the name of the network adapter to search for.
.PARAMETER Property
    Specifies an optional property to test for on the adapter. 
.PARAMETER Should 
    A Script Block defining a Pester Assertion.
.EXAMPLE
    interface ethernet0 { should not BeNullOrEmpty }
.EXAMPLE
    interface ethernet0 status { should be 'up' }
.EXAMPLE
    Interface Ethernet0 linkspeed { should be '1 gbps' } 
.EXAMPLE
    Interface Ethernet0 macaddress { should be '00-0C-29-F2-69-DD' }
.NOTES
    Assertions: Be, BeNullOrEmpty
#>
function Interface {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
        [Parameter(Mandatory, Position=0,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=0,ParameterSetName="Property")]
        [Object]$Target,
        
        [Parameter(Position=1,ParameterSetName="Property")]
        [ValidateSet('DriverVersion','ifAlias','ifDesc','ifIndex','ifName','InterfaceAlias','LinkLayerAddress','ActiveMaximumTransmissionUnit',
        'AdditionalAvailability','AdminLocked','AutoSense','Availability','AvailableRequestedStates','Caption','CommunicationStatus',
        'ComponentID','ConnectorPresent','CreationClassName','Description','DetailedStatus','DeviceID','DeviceName','DeviceWakeUpEnable',
        'DriverDate','DriverDateData','DriverDescription','DriverMajorNdisVersion','DriverMinorNdisVersion','DriverName','DriverProvider',
        'DriverVersionString','ElementName','EnabledDefault','EnabledState','EndPointInterface','ErrorCleared','ErrorDescription','FullDuplex',
        'HardwareInterface','HealthState','Hidden','HigherLayerInterfaceIndices','IdentifyingDescriptions','IMFilter','InstallDate',
        'InstanceID','InterfaceAdminStatus','InterfaceDescription','InterfaceGuid','InterfaceIndex','InterfaceName',
        'InterfaceOperationalStatus','InterfaceType','iSCSIInterface','LastErrorCode','LinkTechnology','LowerLayerInterfaceIndices',
        'MajorDriverVersion','MaxQuiesceTime','MaxSpeed','MediaConnectState','MediaDuplexState','MinorDriverVersion','MtuSize','Name',
        'NdisMedium','NdisPhysicalMedium','NetLuid','NetLuidIndex','NetworkAddresses','NotUserRemovable','OperatingStatus','OperationalStatus',
        'OperationalStatusDownDefaultPortNotAuthenticated','OperationalStatusDownInterfacePaused','OperationalStatusDownLowPowerState',
        'OperationalStatusDownMediaDisconnected','OtherEnabledState','OtherIdentifyingInfo','OtherLinkTechnology','OtherNetworkPortType',
        'OtherPortType','PermanentAddress','PnPDeviceID','PortNumber','PortType','PowerManagementCapabilities','PowerManagementSupported',
        'PowerOnHours','PrimaryStatus','PromiscuousMode','PSComputerName','ReceiveLinkSpeed','RequestedSpeed','RequestedState','Speed','State',
        'StatusDescriptions','StatusInfo','SupportedMaximumTransmissionUnit','SystemCreationClassName','SystemName','TimeOfLastStateChange',
        'TotalPowerOnHours','TransitioningToState','TransmitLinkSpeed','UsageRestriction','Virtual','VlanID','WdmInterface','AdminStatus',
        'DriverFileName','DriverInformation','ifOperStatus','LinkSpeed','MacAddress','MediaConnectionState','MediaType','NdisVersion',
        'PhysicalMediaType','Status')]
        [string]$Property,
        
        [Parameter(Mandatory, Position=1,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=2,ParameterSetName="Property")]
        [scriptblock]$Should
    )
    
    Switch -Exact (Get-TargetType -Target $Target) {
        'String' {
            $expression = {Get-NetAdapter -Name $Target -ErrorAction SilentlyContinue};
            break;
        }
        'Hashtable' {
            $expression = {Get-NetAdapter @Target -ErrorAction SilentlyContinue};
            break;
        }
    }
    
    #$expression = {Get-NetAdapter -Name '$Target' -ErrorAction SilentlyContinue}

    $params = Get-PoshspecParam -TestName Interface -TestExpression $expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}
