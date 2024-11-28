
<#
.SYNOPSIS
Update the ContactEmail tag on provided resource group
.DESCRIPTION
Script will update the ContactEmail tag on provided resource group
testing
.PARAMETER SubscriptionName - Provide the subscription where resource groups resides
    ResourceGroupName - Provide the resource group where tag needs to be updated
.EXAMPLE
.\UpdateAztag_testtt.ps1 -SubscriptionName "GITAKANT-PAYASYOUGO-BRICICI" -ResourceGroupName (get-Content -Path .\rg.csv) -ShowProgress -Verbose
#>

[CmdletBinding()]
param(
  [parameter(Mandatory=$True,
             HelpMessage="Enter the subscription name")]
  [string]$SubscriptionName,
  [parameter(Mandatory=$True,
             ValueFromPipeline=$True,
             ValueFromPipelineByPropertyName=$True,
             HelpMessage="Enter the resource group name")]
  [string[]]$ResourceGroupName,
  [switch]$ShowProgress = $True
  
)

BEGIN
    {
        Write-Output -Message "Selecting subscription $($SubscriptionName)"
        Select-AzSubscription -SubscriptionName $SubscriptionName -Verbose

        $each_rg = (100 / ($ResourceGroupName.Count) -as [int])
        $current_complete = 0
    }
PROCESS
    {    
        foreach($ResourceGroup in $ResourceGroupName)
        {    

            if($ShowProgress) {Write-Progress -Activity "Working on $ResourceGroup" -PercentComplete $current_complete}
            #Get RG where we need to update tag value
            Write-Output -Message "Selecting Resource Group where we need to update tag $($ResourceGroup)"
            $RG = Get-AzResourceGroup -Name $ResourceGroup -Verbose

            $tags = @{"ContactEmail" = "bhagwatmungal@gmail.com"}

            Write-Output -Message "Replacing the ContactEmail Tag value to bhagwatmungal@gmail.com"
            if($tags.Count -ne 0)
            {
            Update-AzTag -ResourceId $RG.ResourceId -Tag $tags -Operation Merge -Verbose
            Write-Output "Tag updated successfully."
            }
            else
            {Write-Output "No tags to be updated"}
        }
    }
END{
       if($ShowProgress){Write-Progress -Activity "Done" -Completed}
   }