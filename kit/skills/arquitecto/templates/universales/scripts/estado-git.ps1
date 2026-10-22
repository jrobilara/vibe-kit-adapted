# Recolector mecánico de git para /estado y encargos (Misión 4 — Diseño A y C).
# Devuelve un objeto JSON en stdout con claves fijas:
#   rama, ultimo_commit, commits_recientes, pendientes_de_push, arbol_limpio, archivos_modificados

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rama = (git rev-parse --abbrev-ref HEAD 2>$null)
if (-not $rama) { $rama = "HEAD" } else { $rama = $rama.Trim() }

$ultimoRaw = (git log -1 --format="%h`t%cI`t%s" 2>$null)
$ultimoCommit = $null
if ($ultimoRaw) {
    $p = $ultimoRaw -split "`t", 3
    $ultimoCommit = [ordered]@{
        sha     = $p[0]
        fecha   = $p[1]
        mensaje = $p[2]
    }
}

$recientesRaw = @(git log -10 --format="%h`t%cI`t%s" 2>$null)
$commitsRecientes = @()
foreach ($line in $recientesRaw) {
    if ($line -and $line.Trim() -ne "") {
        $p = $line -split "`t", 3
        $commitsRecientes += [ordered]@{
            sha     = $p[0]
            fecha   = $p[1]
            mensaje = $p[2]
        }
    }
}

$upstream = (git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>$null)
$pendientesPush = 0
if ($LASTEXITCODE -eq 0 -and $upstream) {
    $upstream = $upstream.Trim()
    $cnt = (git rev-list --count "$upstream..HEAD" 2>$null)
    if ($LASTEXITCODE -eq 0 -and $cnt) {
        $pendientesPush = [int]$cnt.Trim()
    }
} else {
    foreach ($rem in @("origin/$rama", "upstream/$rama")) {
        $verify = (git rev-parse --verify $rem 2>$null)
        if ($LASTEXITCODE -eq 0 -and $verify) {
            $cnt = (git rev-list --count "$rem..HEAD" 2>$null)
            if ($LASTEXITCODE -eq 0 -and $cnt) {
                $pendientesPush = [int]$cnt.Trim()
                break
            }
        }
    }
}

$statusLines = @(git status --porcelain 2>$null)
$archivosMod = @()
foreach ($s in $statusLines) {
    if ($s -and $s.Trim() -ne "") {
        $archivosMod += $s.Trim()
    }
}
$arbolLimpio = ($archivosMod.Count -eq 0)

$resultado = [ordered]@{
    rama                 = $rama
    ultimo_commit        = $ultimoCommit
    commits_recientes    = $commitsRecientes
    pendientes_de_push   = $pendientesPush
    arbol_limpio         = $arbolLimpio
    archivos_modificados = $archivosMod
}

$resultado | ConvertTo-Json -Depth 4
