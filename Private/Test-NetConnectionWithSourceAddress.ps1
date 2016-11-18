Function Test-NetConnectionWithSourceAddress
{
    [CmdletBinding()]
    [Alias('PortTestWithSource')]
    [OutputType([Boolean])]
    Param
    (
        # Specify the remote destination IPAddress.
        [Parameter(Mandatory=$False,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        [Alias('Destination')]
        [string[]]$Computername,

        # Specify the remote destination port to check.
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=1)]
        [ValidateRange(1,65535)]
        [Alias('DestinationPort')]
        [int]$Port,

        # Specify the source IPAddress to use.
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=2)]
        [ipaddress]$SourceIP

    )
    Process
    {
        Write-Verbose -Message "Invoked. Destination -> $Destination ; DestinationPort -> $Port ; SourceIP -> $SourceIP"
        TRY {
            Write-Verbose -Message "Creating list of locally used ports."
            $UsedLocalPorts = ([System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()).GetActiveTcpListeners() | 
                                where -FilterScript {$PSitem.AddressFamily -eq 'Internetwork'} | 
                                Select -ExpandProperty Port
            # select a non-used port
            do {
                $localport = $(Get-Random -Minimum 49152 -Maximum 65535 )
            } until ( $UsedLocalPorts -notcontains $localport)
            Write-Verbose -Message "Found an unused local port -> $LocalPort"
        
            Write-Verbose -Message "Creating a Local EndPoint"
            $LocalIPEndPoint = New-Object -TypeName System.Net.IPEndPoint -ArgumentList  $SourceIP,$localport
            Write-Verbose -Message "Local Endpoint created $LocalIPEndpoint"
        }
        CATCH {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }

        TRY {
            $TCPClient = New-Object -TypeName System.Net.Sockets.TcpClient -ArgumentList $LocalIPEndPoint
            Write-Verbose -Message "Created a TCPClient"
            $TCPClient.Connect($Computername,$port)
            if ($TCPClient.Connected) {
                # Port is Open
                Write-Verbose -Message "TCPClient successfully connected to Destination -> $Computername on Port -> $Port"
                Write-Output -InputObject $true
            }
            else {
                # Port is not open
                Write-Verbose -Message "TCPClient unable to connect to Destination -> $Computername on Port -> $Port"
                Write-Output -InputObject $false
            }
        }
        CATCH {
            # DO something here    
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    
    } #end Process
}