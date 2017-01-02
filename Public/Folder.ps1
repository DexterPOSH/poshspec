<#
.SYNOPSIS
    Test if a folder exists.
.DESCRIPTION
    Test if a folder exists.
.PARAMETER Target
    The path of the folder to search for.
.PARAMETER Should 
    A Script Block defining a Pester Assertion.  
.EXAMPLE
    folder $env:ProgramData { should exist }        
.EXAMPLE
    folder C:\badfolder { should not exist }
.NOTES
    Assertions: exist
#>
function Folder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [Alias('Path')]
        [Object]$Target,
        
        [Parameter(Mandatory, Position=1)]
        [scriptblock]$Should
    )
    
    Switch -Exact (Get-TargetType -Target $Target) {
        'String' {
            $expression = {'$Target'};
            break;
        }
        'Hashtable' {
            Write-Error -Message "Folder - requires a single input. Path of the Folder to be tested."
            break
        }
    }
    
    $params = Get-PoshspecParam -TestName File -TestExpression $expression  @PSBoundParameters

    
    Invoke-PoshspecExpression @params
}