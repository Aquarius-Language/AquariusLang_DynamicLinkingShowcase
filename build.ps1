param(
    [string]$Aqua = 'aqua',
    [string[]]$LibraryTargets = @('windows-x64', 'web', 'android-arm64-v8a', 'android-x86_64'),
    [string[]]$Targets = @('wasm'),
    [switch]$LibrariesOnly
)
$ErrorActionPreference = 'Stop'
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
        'web' { 'dist/web' }
        'android' { 'dist/android/Showcase.apk' }
        default { throw "Unknown export target: $target" }
    }
    Invoke-Aqua @('build',$PSScriptRoot,'--target',$target,'-o',(Join-Path $PSScriptRoot $output))
}
