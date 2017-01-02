<#
.SYNOPSIS
    Test a Service.
.DESCRIPTION
    Test the attributes of a Service.
.PARAMETER Target
    Specifies the service names of service.
.PARAMETER Should 
    A Script Block defining a Pester Assertion.
.PARAMETER Property 
    Property on the Service controller object to be used within Pester Assertion.    
.EXAMPLE
    Service w32time StartupType { Should Be Automatic }
.EXAMPLE
    Service bits Status { Should Be Stopped }
.NOTES
    #Only validates the Status property. Assertions: Be
    Now validates an explicit property name supplied to it.
#>
function Service {
    [CmdletBinding(DefaultParameterSetName='default')]
    param( 
        [Parameter(Mandatory, Position=0)]
        [Alias("Name")]
        [Object]$Target,

        [Parameter(Position=1, ParameterSetName='default')]
        [ValidateSet('Name','RequiredServices','CanPauseAndContinue','CanShutdown','CanStop','Container','DependentServices',
        'DisplayName','MachineName','ServiceHandle','ServiceName','ServicesDependedOn','ServiceType','Site','StartType','Status')]
        [string]$Property,

        [Parameter(Mandatory, Position=1, ParameterSetName='noprop')]
        [Parameter(Mandatory, Position=2, ParameterSetName='default')]
        [scriptblock]$Should
    )

    Switch -Exact (Get-TargetType -Target $Target) {
        'String' {
            $expression = {Get-Service -Name $Target -ErrorAction SilentlyContinue};
            break;
        }
        'Hashtable' {
            $expression = {Get-Service @Target -ErrorAction SilentlyContinue};
            break;
        }
    }
    
    $params = Get-PoshspecParam -TestName Service -TestExpression $Expression @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}