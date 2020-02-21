#ps1
function Add-LocalAdmin {
    # Usage: Add-LocalAdmin -Name MyUsername -Password MyPassword
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
