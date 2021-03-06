function Remove-EndpointSession{
    <#
    .SYNOPSIS
        Removes an endpoint session
    .DESCRIPTION
        Removes an endpoint session
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$Target
    )

    # Create output dictionary
    $output = @{
        "ObjectName" = "SessionRemoved"
        "DateTime" = (Get-Date).ToString()
        "Outcome" = "Failed"
    }

    # Find the session in the GlobalTargetList
    $contains = $GlobalTargetList.Contains($Target)

    # If the session exists, be awesome, close the session down then remove from the GlobalTargetList
    if($contains -eq $true){
        Get-PSSession | Where-Object {$_.ComputerName -eq $Target} | Remove-PSSession
        $output.Add("Endpoint", $Target)
        $GlobalTargetList.Remove($Target)
        $output.Outcome = "Success"
    }else{
        $message = $Target + ": Endpoint does not exist in target list"
        Write-HostHunterInformation -MessageData $message
        $output.Outcome = "DoesNotExist"
    }

    Write-Output $output

}