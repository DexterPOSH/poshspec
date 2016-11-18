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
        [Parameter(Mandatory, Position=1)]
        [Alias('Path')]
        [HashTable]$TargetHash,
        
        [Parameter(Mandatory, Position=2)]
        [scriptblock]$Should
    )
    

    $params = Get-PoshspecParam -TestName Folder -TestExpression {Test-Path -PathType Container @TargetHash} @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}