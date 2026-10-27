<#
.SYNOPSIS
Packages the Borland Blue Eclipse theme as a plug-in jar.

.DESCRIPTION
Writes dist/<Bundle-SymbolicName>_<Bundle-Version>.jar. Copy the jar into the
dropins folder of an Eclipse installation to install the theme.

.PARAMETER EclipseHome
Optional Eclipse installation folder. When given, the jar is also copied into
its dropins folder, replacing any previously installed Borland Blue jar.

.EXAMPLE
./build.ps1

.EXAMPLE
./build.ps1 -EclipseHome C:\Downloads\eclipse
#>
[CmdletBinding()]
param(
  [string]$EclipseHome
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = $PSScriptRoot
$manifest = Get-Content -Raw (Join-Path $root 'META-INF/MANIFEST.MF')
$symbolicName = [regex]::Match($manifest, '(?m)^Bundle-SymbolicName:\s*([^;\s]+)').Groups[1].Value
$version = [regex]::Match($manifest, '(?m)^Bundle-Version:\s*(\S+)').Groups[1].Value

# The manifest goes first so java.util.jar.JarInputStream can find it.
$files = @('META-INF/MANIFEST.MF', 'plugin.xml', 'LICENSE') +
  @(Get-ChildItem (Join-Path $root 'css') -Filter *.css | ForEach-Object { "css/$($_.Name)" }) +
  @(Get-ChildItem (Join-Path $root 'textmate') -Filter *.json | ForEach-Object { "textmate/$($_.Name)" })

$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null
$jarPath = Join-Path $dist "${symbolicName}_$version.jar"
if (Test-Path $jarPath) { Remove-Item $jarPath }

$zip = [IO.Compression.ZipFile]::Open($jarPath, [IO.Compression.ZipArchiveMode]::Create)
try {
  foreach ($file in $files) {
    [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, (Join-Path $root $file), $file) | Out-Null
  }
} finally {
  $zip.Dispose()
}
Write-Host "Built $jarPath"

if ($EclipseHome) {
  if (-not (Test-Path (Join-Path $EclipseHome 'eclipse.ini'))) {
    throw "No Eclipse installation found at $EclipseHome"
  }
  $dropins = Join-Path $EclipseHome 'dropins'
  New-Item -ItemType Directory -Force $dropins | Out-Null
  Get-ChildItem $dropins -Filter "${symbolicName}_*.jar" | Remove-Item
  Copy-Item $jarPath $dropins
  Write-Host "Installed into $dropins"
  Write-Host 'Restart Eclipse, then choose Borland Blue under Window > Preferences > General > Appearance.'
}
