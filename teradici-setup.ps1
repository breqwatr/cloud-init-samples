#ps1

#########################################################################################
# Create a local service account user for administration and apply the Teradici license #
#########################################################################################

#ps1

# Add a user as local administrator

function Add-LocalAdmin {
    # Create a local user account and add the user as a local administrator
    # Usage: Add-LocalAdmin -Name Test10 -Password Password1
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $Name,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $Password
    )
    $new_user = Get-LocalUser | where {$_.name -eq $Name}
    if ($new_user -eq $null){
        $password_secure_string = ConvertTo-SecureString -AsPlainText -Force $Password
        $new_user = New-LocalUser -Name $Name -Password $password_secure_string -AccountNeverExpires
    }
    $user_local_admin = Get-LocalGroupMember 'Administrators' | where {$_.name -Like "*\$($new_user.name)"}
    if ($user_local_admin -eq $null){
        Add-LocalGroupMember -Group "Administrators" -Member $new_user
    }
    return $new_user
}

# To set the registry key
function Register-TeradiciAgent {
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $RegistrationCode
    )
    $filename = Join-Path (Split-Path ((get-ItemProperty "HKLM:\SOFTWARE\Teradici\PCoIPAgent").PCoIPServerPath)) "pcoip-license-tool.exe"
    $expression = "& '$filename' register --registration-code $RegistrationCode"
    Invoke-Expression $expression
}

# Usage:
# Add-LocalAdmin -Name MyUsername -Password MyPassword
# Register-TeradiciAgent -RegistrationCode "VVVVVVVVVVVV@1111-1111-1111-1111"
