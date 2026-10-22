# kit/skills/ <-> ~/.gemini/config/skills/ - compara (default) o sincroniza las 5 skills canonicas.
#   powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1          -> diff (lo usa /inicio y doctor)
#   powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1 sync     -> copia kit/ -> ~/.gemini/config/skills/ y despues diff (lo usa /cierre)
# La linea "Carpeta de proyectos de esta maquina" del Arquitecto es de cada PC (ADR-023):
# el diff la ignora y el sync la conserva. Sale con 1 si algo no da limpio.

param(
    [string]$Mode = "diff"
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ProjectDir = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$HomeSkills = Join-Path $HOME ".gemini\config\skills"
$Skills = @("arquitecto", "arquitecto-skills", "docs-personales", "redteam-spec", "relevamiento")
$LineaPrefix = "**Carpeta de proyectos de esta m" + [char]0x00E1 + "quina**"
$ArqInstalled = Join-Path $HomeSkills "arquitecto\SKILL.md"

function Get-ProyectosRuta([string]$FilePath) {
    if (-not (Test-Path $FilePath)) { return "" }
    $lines = [System.IO.File]::ReadAllLines($FilePath, [System.Text.Encoding]::UTF8)
    foreach ($line in $lines) {
        if ($line.StartsWith($LineaPrefix)) {
            $parts = $line.Split('`')
            if ($parts.Length -ge 2) {
                return $parts[1]
            }
        }
    }
    return ""
}

if ($Mode -eq "sync") {
    $ruta = Get-ProyectosRuta $ArqInstalled
    if ($ruta -eq "{{CARPETA_DE_PROYECTOS}}") { $ruta = "" }

    foreach ($s in $Skills) {
        $src = Join-Path $ProjectDir "kit\skills\$s"
        $dst = Join-Path $HomeSkills $s
        if (Test-Path $dst) {
            Remove-Item -Path $dst -Recurse -Force
        }
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
        Copy-Item -Path (Join-Path $src "*") -Destination $dst -Recurse -Force
    }

    if ($ruta -ne "") {
        $raw = [System.IO.File]::ReadAllText($ArqInstalled, [System.Text.Encoding]::UTF8)
        $targetStr = $LineaPrefix + ": ``{{CARPETA_DE_PROYECTOS}}``"
        $replaceStr = $LineaPrefix + ": ``" + $ruta + "``"
        $raw = $raw.Replace($targetStr, $replaceStr)
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($ArqInstalled, $raw, $utf8NoBom)
        Write-Output ("sync hecho - carpeta de proyectos de esta PC conservada: " + $ruta)
    } else {
        Write-Output ("sync hecho - ATENCION: esta PC no tenia carpeta de proyectos: completa la linea en " + $ArqInstalled)
    }
}

$sucio = 0

function Normalize-Content([string]$FilePath) {
    $raw = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::UTF8)
    $norm = $raw -replace "`r`n", "`n"
    $lines = $norm -split "`n"
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($l in $lines) {
        if ($l.StartsWith($LineaPrefix)) {
            $out.Add($LineaPrefix + ": <IGNORED_BY_SYNC>")
        } else {
            $out.Add($l)
        }
    }
    return ($out -join "`n")
}

$okMark = [char]0x2713
$errMark = [char]0x2717
$arrowMark = [char]0x2194

foreach ($s in $Skills) {
    $srcDir = (Resolve-Path (Join-Path $ProjectDir "kit\skills\$s")).Path
    $dstDir = Join-Path $HomeSkills $s
    $skillDiffs = New-Object System.Collections.Generic.List[string]

    if (-not (Test-Path $dstDir)) {
        $skillDiffs.Add("Falta carpeta instalada: $dstDir")
    } else {
        $dstDir = (Resolve-Path $dstDir).Path
        $srcFiles = @(Get-ChildItem -Path $srcDir -Recurse -File | ForEach-Object { $_.FullName.Substring($srcDir.Length + 1).Replace('\', '/') })
        $dstFiles = @(Get-ChildItem -Path $dstDir -Recurse -File | ForEach-Object { $_.FullName.Substring($dstDir.Length + 1).Replace('\', '/') })

        $allRel = ($srcFiles + $dstFiles) | Select-Object -Unique | Sort-Object
        foreach ($rel in $allRel) {
            $fSrc = Join-Path $srcDir ($rel.Replace('/', '\'))
            $fDst = Join-Path $dstDir ($rel.Replace('/', '\'))
            if (-not (Test-Path $fSrc)) {
                $skillDiffs.Add("Solo en instalado: $s/$rel")
            } elseif (-not (Test-Path $fDst)) {
                $skillDiffs.Add("Falta en instalado: $s/$rel")
            } else {
                $cSrc = Normalize-Content $fSrc
                $cDst = Normalize-Content $fDst
                if ($cSrc -cne $cDst) {
                    $skillDiffs.Add("Difiere contenido: $s/$rel")
                }
            }
        }
    }

    if ($skillDiffs.Count -eq 0) {
        Write-Output "$okMark skills/$s"
    } else {
        Write-Output "$errMark skills/$s"
        foreach ($d in $skillDiffs) { Write-Output "  $d" }
        $sucio = 1
    }
}

$rutaFinal = Get-ProyectosRuta $ArqInstalled
if ($rutaFinal -eq "{{CARPETA_DE_PROYECTOS}}" -or $rutaFinal -eq "") {
    Write-Output ("ATENCION: la carpeta de proyectos de esta PC esta sin completar (" + $ArqInstalled + ")")
    $sucio = 1
}

if ($sucio -eq 0) {
    Write-Output "kit $arrowMark ~/.gemini/config: LIMPIO"
    exit 0
} else {
    Write-Output "kit $arrowMark ~/.gemini/config: SUCIO - frenar y mirar antes de pisar nada"
    exit 1
}
