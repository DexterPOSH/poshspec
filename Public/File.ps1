<#
.SYNOPSIS
    Test a File.
.DESCRIPTION
    Test the Existance or Contents of a File..
.PARAMETER Target
    Specifies the path to an item.
.PARAMETER Should 
    A Script Block defining a Pester Assertion.       
.EXAMPLE
    File C:\inetpub\wwwroot\iisstart.htm { Should Exist }
.EXAMPLE
    File C:\inetpub\wwwroot\iisstart.htm { Should Contain 'text-align:center' }
.NOTES
    Assertions: Exist and Contain
#> 
  function File {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=1)]
        [Alias("Path")]
        [HashTable]$TargetHash,
        
        [Parameter(Mandatory, Position=2)]
        [scriptblock]$Should
    )
 
    $params = Get-PoshspecParam -TestName File -TestExpression {Test-Path -PathType Leaf @TargetHash}  @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}