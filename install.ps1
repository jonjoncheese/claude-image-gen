# claude-image-gen installer for Windows (PowerShell 5.1+):
#   irm https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/main/install.ps1 | iex
$ErrorActionPreference = 'Stop'
$src = if ($env:CIG_REPO) { $env:CIG_REPO } else { 'https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/main' }
$dir = Join-Path $env:LOCALAPPDATA 'claude-image-gen'

function Test-Node {
  try { return [int](node -p "process.versions.node.split('.')[0]") -ge 22 } catch { return $false }
}

if (-not (Test-Node)) {
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host 'Installing Node.js LTS with winget...'
    winget install --id OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
  }
  if (-not (Test-Node)) {
    Write-Host 'claude-image-gen needs Node.js 22 or newer. Install it from https://nodejs.org, then run this again.'
    return
  }
}

New-Item -ItemType Directory -Force -Path $dir | Out-Null
Invoke-WebRequest -UseBasicParsing -Uri "$src/claude-image-gen.js" -OutFile (Join-Path $dir 'claude-image-gen.js')
# One shim for cmd and PowerShell, one for Git Bash (which is what Claude Code uses on Windows).
Set-Content -Encoding Ascii -Path (Join-Path $dir 'claude-image-gen.cmd') -Value '@node "%~dp0claude-image-gen.js" %*'
[IO.File]::WriteAllText((Join-Path $dir 'claude-image-gen'), "#!/bin/sh`nexec node `"`$(dirname `"`$0`")/claude-image-gen.js`" `"`$@`"`n")

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-not $userPath) { $userPath = '' }
if (-not (($userPath -split ';') -contains $dir)) {
  [Environment]::SetEnvironmentVariable('Path', ($userPath.TrimEnd(';') + ';' + $dir).TrimStart(';'), 'User')
  $env:Path += ";$dir"
}
$v = node (Join-Path $dir 'claude-image-gen.js') --version
Write-Host "Installed claude-image-gen $v in $dir"
Write-Host 'Open a new terminal, then run: claude-image-gen login'
