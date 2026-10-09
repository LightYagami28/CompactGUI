[CmdletBinding()]
param(
    [string]$DependencyDirectory
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($DependencyDirectory)) {
    $DependencyDirectory = Join-Path (Split-Path -Parent $PSScriptRoot) '..\LazyTranslate'
}
$dependencyRoot = [IO.Path]::GetFullPath($DependencyDirectory)
$dependencyUrl = 'https://github.com/IridiumIO/LazyTranslate.git'
$dependencyCommit = '2fcbaab755fc8217db44cf4924113a330fdc0c70'
$artifactDirectory = Join-Path $dependencyRoot 'artifacts'

if (-not (Test-Path (Join-Path $dependencyRoot '.git'))) {
    if (Test-Path $dependencyRoot) {
        throw "Il percorso esiste ma non è il checkout atteso: $dependencyRoot"
    }

    git clone --depth 1 $dependencyUrl $dependencyRoot
    if ($LASTEXITCODE -ne 0) { throw 'Clone di LazyTranslate non riuscito.' }
}

$status = git -C $dependencyRoot status --porcelain
if ($LASTEXITCODE -ne 0) { throw 'Impossibile verificare il checkout LazyTranslate.' }
if ($status) { throw "LazyTranslate contiene modifiche locali; non verranno sovrascritte: $dependencyRoot" }

git -C $dependencyRoot fetch --depth 1 origin $dependencyCommit
if ($LASTEXITCODE -ne 0) { throw 'Download della revisione fissata di LazyTranslate non riuscito.' }
git -C $dependencyRoot checkout --detach $dependencyCommit
if ($LASTEXITCODE -ne 0) { throw 'Selezione della revisione fissata di LazyTranslate non riuscita.' }

New-Item -ItemType Directory -Force -Path $artifactDirectory | Out-Null
$projects = @(
    (Join-Path $dependencyRoot 'LazyTranslate\LazyTranslate.vbproj'),
    (Join-Path $dependencyRoot 'LazyTranslate.CatalogueBuilder\LazyTranslate.CatalogueBuilder.vbproj')
)
foreach ($project in $projects) {
    dotnet build $project --configuration Release -p:Version=0.1.5
    if ($LASTEXITCODE -ne 0) { throw "Build dipendenza fallita: $project" }
    dotnet pack $project --configuration Release --no-build -p:Version=0.1.5 --output $artifactDirectory
    if ($LASTEXITCODE -ne 0) { throw "Pack dipendenza fallito: $project" }
}
