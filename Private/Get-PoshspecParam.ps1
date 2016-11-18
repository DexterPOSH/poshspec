function Get-PoshspecParam {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $TestName,
        [Parameter(Mandatory)]
        [string]
        $TestExpression,        
        [Parameter(Mandatory)]
        [HashTable]
        $TargetHash,        
        [Parameter()]
        [string]
        $FriendlyName,            
        [Parameter()]
        [string]
        $Property,
        [Parameter()]
        [string]
        $Qualifier,                   
        [Parameter(Mandatory)]
        [scriptblock]
        $Should
    )
    
    $assertion = $Should.ToString().Trim()

    if (-not $PSBoundParameters.ContainsKey("FriendlyName"))
    {
        $FriendlyName = $TargetHash.GetEnumerator() |
                            ForEach-Object -Begin {
                                $outString = ""
                            } -Process {
                                $outString = $outString + ( "{0} -> {1} ;" -f $PSItem.Key, $PSItem.Value)
                            } -End {
                                $outString
                            }

    }
 
    $expressionString = $TestExpression.ToString().Trim()

    if ($PSBoundParameters.ContainsKey("Property"))
    {
        $expressionString += " | Select-Object -ExpandProperty '$Property'"
        
        if ($PSBoundParameters.ContainsKey("Qualifier"))
        {
            $nameString = "{0} property '{1}' for '{2}' at '{3}' {4}" -f $TestName,$Property, $FriendlyName, $Qualifier, $assertion
        }
        else 
        {
            $nameString = "{0} property '{1}' for '{2}' {3}" -f $TestName, $Property, $FriendlyName, $assertion            
        }        
    }
    else 
    {
        $nameString = "{0} '{1}' {2}" -f $TestName, $FriendlyName, $assertion
    }

    $expressionString = $ExecutionContext.InvokeCommand.ExpandString($expressionString)
    
    $expressionString += " | $assertion"
    
    Write-Output -InputObject ([PSCustomObject]@{Name = $nameString; Expression = $expressionString})
}
