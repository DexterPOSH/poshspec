Function Get-TargetType
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        # Specify the remote destination IPAddress.
        [Parameter(Mandatory=$True,
                    Position=0)]
        [Object]$Target

    )
    if ($Target -is [String]) {
        'String'
    }
    elseif ($Target -is [Hashtable]) {
        'Hashtable'
    }
    else {
        # throw an error here
        throw "Target can either be a String or Hashtable."   
    }
}