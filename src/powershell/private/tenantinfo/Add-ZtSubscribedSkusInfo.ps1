<#
.SYNOPSIS
    Add subscribed SKU (license) information to tenant overview.
#>
function Add-ZtSubscribedSkusInfo {
    [CmdletBinding()]
    param()

    $activity = "Getting subscribed SKUs"
    Write-ZtProgress -Activity $activity -Status "Processing"

    try {
        $rawSkus = Invoke-ZtGraphRequest -RelativeUri 'subscribedSkus' -ErrorAction Stop

        $skuList = $rawSkus | ForEach-Object {
            [PSCustomObject]@{
                SkuId          = $_.skuId
                SkuPartNumber  = $_.skuPartNumber
                DisplayName    = if ($_.skuDisplayName) { $_.skuDisplayName } else { $_.skuPartNumber }
                PrepaidEnabled = [int]($_.prepaidUnits.enabled ?? 0)
                PrepaidWarning = [int]($_.prepaidUnits.warning ?? 0)
                ConsumedUnits  = [int]($_.consumedUnits ?? 0)
            }
        }

        $result = [PSCustomObject]@{
            Skus         = $skuList
            LicenseTiers = [PSCustomObject]@{
                EntraID         = Get-ZtLicenseInformation -Product EntraID
                EntraWorkloadID = Get-ZtLicenseInformation -Product EntraWorkloadID
                Intune          = Get-ZtLicenseInformation -Product Intune
            }
        }

        Add-ZtTenantInfo -Name "SubscribedSkus" -Value $result
    }
    catch {
        Write-PSFMessage -Level Warning -Message "Failed to retrieve subscribed SKUs: $_" -ErrorRecord $_
    }

    Write-ZtProgress -Activity $activity -Status "Completed"
}
