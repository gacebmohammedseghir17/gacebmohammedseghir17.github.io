$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$publicDir = Join-Path $repoRoot "public"

hugo --source $repoRoot | Out-Null

function Assert-FileExists {
    param(
        [string]$Path,
        [string]$Label
    )

    if (-not (Test-Path $Path)) {
        throw "Missing file for ${Label}: $Path"
    }
}

function Assert-Contains {
    param(
        [string]$Path,
        [string]$Needle,
        [string]$Label
    )

    $content = Get-Content -Raw -Path $Path
    if ($content -notmatch [regex]::Escape($Needle)) {
        throw "Missing '$Needle' in ${Label} ($Path)"
    }
}

$homePath = Join-Path $publicDir "index.html"
$projectsPath = Join-Path $publicDir "projects\index.html"
$aboutPath = Join-Path $publicDir "about\index.html"
$resumePath = Join-Path $publicDir "resume\index.html"

Assert-FileExists -Path $homePath -Label "homepage"
Assert-FileExists -Path $projectsPath -Label "projects page"
Assert-FileExists -Path $aboutPath -Label "about page"
Assert-FileExists -Path $resumePath -Label "resume page"

Assert-Contains -Path $homePath -Needle "Featured Projects" -Label "homepage"
Assert-Contains -Path $homePath -Needle "Technical Focus" -Label "homepage"
Assert-Contains -Path $homePath -Needle "Projects" -Label "homepage nav"
Assert-Contains -Path $homePath -Needle "About" -Label "homepage nav"
Assert-Contains -Path $homePath -Needle "Resume" -Label "homepage nav"

Assert-Contains -Path $projectsPath -Needle "Featured Projects" -Label "projects page"
Assert-Contains -Path $aboutPath -Needle "Current Focus" -Label "about page"
Assert-Contains -Path $resumePath -Needle "Resume Snapshot" -Label "resume page"

Write-Host "Site validation passed."
