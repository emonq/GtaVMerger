$steamDirs = "Installers"
$steamFiles = "commandline.txt", "GTAVLanguageSelect.exe", "GTAVLauncher.exe", "GTA5.exe", "installscript.vdf", "PlayGTAV.exe", "steam_api64.dll"

$epicDirs = ".egstore", "ReadMe", "Redistributables", "x64\data"
$epicFiles = "update\x64\data\errorcodes\chinesesimp.txt", "EOSSDK-Win64-Shipping.dll", "GPUPerfAPIDX11-x64.dll", "GTA5.exe", "NvPmApi.Core.win64.dll", "PlayGTAV.exe", "version.txt"

$generalFiles = "update\update.rpf", "update\x64\data\errorcodes\american.txt", "update\x64\data\errorcodes\chinese.txt", "update\x64\data\errorcodes\french.txt", "update\x64\data\errorcodes\german.txt", "update\x64\data\errorcodes\italian.txt", "update\x64\data\errorcodes\japanese.txt", "update\x64\data\errorcodes\korean.txt", "update\x64\data\errorcodes\mexican.txt", "update\x64\data\errorcodes\polish.txt", "update\x64\data\errorcodes\portuguese.txt", "update\x64\data\errorcodes\russian.txt", "update\x64\data\errorcodes\spanish.txt", "x64\metadata.dat", "bink2w64.dll", "common.rpf", "d3dcompiler_46.dll", "d3dcsx_46.dll", "GFSDK_ShadowLib.win64.dll", "GFSDK_TXAA.win64.dll", "GFSDK_TXAA_AlphaResolve.win64.dll", "x64a.rpf", "x64b.rpf", "x64c.rpf", "x64d.rpf", "x64e.rpf", "x64f.rpf", "x64g.rpf", "x64h.rpf", "x64i.rpf", "x64j.rpf", "x64k.rpf", "x64l.rpf", "x64m.rpf", "x64n.rpf", "x64o.rpf", "x64p.rpf", "x64q.rpf", "x64r.rpf", "x64s.rpf", "x64t.rpf", "x64u.rpf", "x64v.rpf", "x64w.rpf"
$generalDirs = "x64\audio", "update\x64\dlcpacks"

do {
    $gtavDir = Read-Host "Enter the location where to store the merged files"
}while ($gtavDir -eq "")
$steam = Read-Host "Enter the location where the steam GTA is, press ENTER if you don't have it yet"
$epic = Read-Host "Enter the location where the epic GTA is, press ENTER if you don't have it yet"

if (($steam -eq "") -and ($epic -eq "")) { Write-Host "It is NOT ALLOWED to have two empty location`nPress anykey to exit" -ForegroundColor Red; [Console]::Readkey() | Out-Null; Exit }
if ($steam -ne "") { $generalSrc = $steam }
Else { $generalSrc = $epic }

$epicDir = Join-Path $gtavDir "Epic"
$steamDir = Join-Path $gtavDir "Steam"
$generalDir = Join-Path $gtavDir "General"

if (-not (Test-Path -Path (Join-Path $steamDir "update\x64\data\errorcodes"))) { mkdir -p (Join-Path $steamDir "update\x64\data\errorcodes") }
if (-not (Test-Path -Path (Join-Path $steamDir "x64"))) { mkdir -p (Join-Path $steamDir "x64") }
if (-not (Test-Path -Path (Join-Path $epicDir "update\x64\data\errorcodes"))) { mkdir -p (Join-Path $epicDir "update\x64\data\errorcodes") }
if (-not (Test-Path -Path (Join-Path $epicDir "x64"))) { mkdir -p (Join-Path $epicDir "x64") }
if (-not (Test-Path -Path (Join-Path $generalDir "update\x64\data\errorcodes"))) { mkdir -p (Join-Path $generalDir "update\x64\data\errorcodes") }
if (-not (Test-Path -Path (Join-Path $generalDir "x64"))) { mkdir -p (Join-Path $generalDir "x64") }

if ($steam -ne "") {
    Foreach ($item in $steamFiles) { Copy-Item (Join-Path $steam $item) (Join-Path $steamDir $item) }
    Foreach ($item in $steamDirs) { Copy-Item (Join-Path $steam $item) (Join-Path $steamDir $item) -recurse }
}
if ($epic -ne ""){
    Foreach ($item in $epicDirs) { Copy-Item (Join-Path $epic $item) (Join-Path $epicDir $item) -recurse }
    Foreach ($item in $epicFiles) { Copy-Item (Join-Path $epic $item) (Join-Path $epicDir $item) }
}

Foreach ($item in $generalFiles) {
    Copy-Item (Join-Path $generalSrc $item) (Join-Path $generalDir $item)
    if (Test-Path -Path (Join-Path $epicDir $item)) { cmd /c rmdir (Join-Path $epicDir $item) }
    if (Test-Path -Path (Join-Path $steamDir $item)) { cmd /c rmdir (Join-Path $steamDir $item) }
    cmd /c mklink /H (Join-Path $epicDir $item) (Join-Path $generalDir $item)
    cmd /c mklink /H (Join-Path $steamDir $item) (Join-Path $generalDir $item)
}
Foreach ($item in $generalDirs) {
    Copy-Item (Join-Path $epic $item) (Join-Path $generalDir $item) -recurse
    if (Test-Path -Path (Join-Path $epicDir $item)) { cmd /c rmdir (Join-Path $epicDir $item) }
    if (Test-Path -Path (Join-Path $steamDir $item)) { cmd /c rmdir (Join-Path $steamDir $item) }
    cmd /c mklink /j (Join-Path $epicDir $item) (Join-Path $generalDir $item)
    cmd /c mklink /j (Join-Path $steamDir $item) (Join-Path $generalDir $item)
}
if ($steam -ne ""){
    Rename-Item -Path $steam $steam"_old"
    cmd /c mklink /j $steam $steamDir
}
Else {
    Write-Host "Enter the path you are going to install steam GTAV to" -ForegroundColor Yellow
    $steam=Read-Host
    cmd /c mklink /j $steam $steamDir
}
if($epic -ne ""){
    Rename-Item -Path $epic $epic"_old"
    cmd /c mklink /j $epic $epicDir
}
Else {
    Write-Host "Enter the path you are going to install epic GTAV to" -ForegroundColor Yellow
    $epic=Read-Host
    Write-Host "!!!!ATTENTION!!!!" -ForegroundColor Red
    Write-Host "Press anykey after you have started the epic GTAV download process and pause to make epic scan the existed files"
    [Console]::Readkey()
    Remove-item $epic\*
    Remove-Item $epic
    cmd /c mklink /j $epic $epicDir
}
Write-Host "Merge completed! The old directories have been renamed to NAME_OLD, remove them manually after you ensure the game runs normally.`nPress anykey to exit" -ForegroundColor Green
[Console]::Readkey() | Out-Null; Exit