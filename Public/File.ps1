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
        [Parameter(Mandatory, Position=0)]
        [Alias("Path")]
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
                #$expression =  {Test-Path -PathType Leaf @Target};
                Write-Error -Message "File - requires a single input. Path of the file to be tested."
                break;
            }
        }
    
    $params = Get-PoshspecParam -TestName File -TestExpression $expression  @PSBoundParameters
    
    Invoke-PoshspecExpression @params
}