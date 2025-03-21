$Props = convertfrom-stringdata (get-content versions.properties | Select-String -pattern "^#" -NotMatch)
$KopsVersion = $Props.UPSTREAM_VERSION
"Building Upstream Version: $KopsVersion"
""

$Checksum = (Invoke-WebRequest "https://github.com/kubernetes/kops/releases/download/v$KopsVersion/kops-windows-amd64.sha256").tostring().trim().ToUpper()

"Discovered Checksum: $Checksum"

if (Test-Path -LiteralPath .\target) {
    Remove-Item -LiteralPath .\target -Recurse
}
New-Item -ItemType Directory -Force -Path .\target\tools | Out-Null

(Get-Content .\src\tools\chocolateyinstall.template.ps1) -replace '%%VERSION%%', $KopsVersion -replace '%%CHECKSUM%%', $Checksum | Out-File -Encoding utf8 ".\target\tools\chocolateyinstall.ps1"
(Get-Content .\src\kubernetes-kops.template.nuspec) -replace '%%VERSION%%', $KopsVersion -replace '%%CHECKSUM%%', $Checksum | Out-File -Encoding utf8 ".\target\kubernetes-kops.nuspec"

