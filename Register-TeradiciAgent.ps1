#ps1
function Register-TeradiciAgent {
    # Usage: Register-TeradiciAgent -RegistrationCode "VVVVVVVVVVVV@1111-1111-1111-1111"
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $RegistrationCode
    )
    $filename = Join-Path (Split-Path ((get-ItemProperty "HKLM:\SOFTWARE\Teradici\PCoIPAgent").PCoIPServerPath)) "pcoip-license-tool.exe"
    $expression = "& '$filename' register --registration-code $RegistrationCode"
    Invoke-Expression $expression
}
