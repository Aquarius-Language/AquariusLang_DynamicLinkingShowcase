param(
    [string]$Aqua = 'aqua',
    [string[]]$LibraryTargets = @(),
    [string[]]$Targets = @('wasm'),
    [switch]$LibrariesOnly
)
$ErrorActionPreference = 'Stop'
# Comma-separated values arrive as one string from other shells (pwsh -File).
$Targets = @($Targets | ForEach-Object { $_ -split ',' } | Where-Object { $_ })
$LibraryTargets = @($LibraryTargets | ForEach-Object { $_ -split ',' } | Where-Object { $_ })
# By default the library's binaries for this host's desktop (each desktop builds its own) and the web, plus Android on
# Windows, where the Android SDK usually is.
if (-not $LibraryTargets.Count) {
    $LibraryTargets = if ($IsMacOS) { @('macos-arm64', 'web') } elseif ($IsLinux) { @('linux-x64', 'web') }
        else { @('windows-x64', 'web', 'android-arm64-v8a', 'android-x86_64') }
}
function Invoke-Aqua([string[]]$Arguments) {
    & $Aqua @Arguments
    if ($LASTEXITCODE -ne 0) { throw "aqua failed ($LASTEXITCODE): $Arguments" }
}
$native = Join-Path $PSScriptRoot 'libraries/showcase'
Invoke-Aqua @('library','build',$native,'--targets',($LibraryTargets -join ','))
if ($LibrariesOnly) { return }
# Refresh the snapshot after rebuilding a local native library.
Invoke-Aqua @('bottle','update','--project',$PSScriptRoot,'--offline')
foreach ($target in $Targets) {
    $output = switch ($target) {
        'wasm' { 'dist/showcase.wasm' }
        'windows' { 'dist/windows/Showcase.exe' }
        'linux' { 'dist/linux/showcase' }
        'macos' { 'dist/macos/Showcase.app' }
        'web' { 'dist/web' }
        'android' { 'dist/android/Showcase.apk' }
        default { throw "Unknown export target: $target" }
    }
    Invoke-Aqua @('build',$PSScriptRoot,'--target',$target,'-o',(Join-Path $PSScriptRoot $output))
}
