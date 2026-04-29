@echo off
setlocal enabledelayedexpansion

set OUTPUT=nasher.cfg

(
echo [package]
echo name = "Package Name"
echo description = "Package Description"
echo version = "1.01prc8"
echo url = ""
echo author = "Original Author"
echo author = ""
echo.
echo   [package.sources]
echo   include = "src/module/**/*.{nss.json}"
echo   include = "src/include/**/*.{nss}"
echo.
echo   [package.rules]
echo   "*" = "src/module/$ext"
echo.
) > %OUTPUT%

REM =========================
REM HAK FILES
REM =========================
for %%f in (*.hak) do (
    set NAME=%%~nf
    (
    echo [target]
    echo name = "!NAME!"
    echo file = "%%~nxf"
    echo group = "haks"
    echo description = "Hak target: !NAME!"
    echo     [target.sources]
    echo         include = "src/hakpak/!NAME!/**/*"
    echo.
    echo     [target.rules]
    echo         "*" = "src/hakpak/!NAME!/$ext"
    echo.
    ) >> %OUTPUT%
)

REM =========================
REM ERF FILES
REM =========================
for %%f in (*.erf) do (
    set NAME=%%~nf
    (
    echo [target]
    echo name = "!NAME!"
    echo file = "%%~nxf"
    echo group = "erf"
    echo description = "ERF target: !NAME!"
    echo     [target.sources]
    echo         include = "src/erf/!NAME!/**/*"
    echo.
    echo     [target.rules]
    echo         "*" = "src/erf/!NAME!/$ext"
    echo.
    ) >> %OUTPUT%
)

REM =========================
REM MODULE FILES (.mod)
REM =========================
for %%f in (*.mod) do (
    set NAME=%%~nf
    (
    echo [target]
    echo name = "!NAME!"
    echo file = "%%~nxf"
    echo group = "module"
    echo description = "Module target: !NAME!"
    echo     [target.sources]
    echo         include = "src/module/**/*"
    echo         include = "src/include/**/*"
    echo.
    echo     [target.rules]
    echo         "*" = "src/module/$ext"
    echo.
    ) >> %OUTPUT%
)

REM =========================
REM TLK FILES
REM =========================
for %%f in (*.tlk) do (
    set NAME=%%~nf
    (
    echo [target]
    echo name = "!NAME!"
    echo file = "%%~nxf"
    echo group = "tlk"
    echo description = "TLK target: !NAME!"
    echo     [target.sources]
    echo         include = "src/tlk/*.json"
    echo.
    echo     [target.rules]
    echo         "*" = "src/tlk/$ext"
    echo.
    ) >> %OUTPUT%
)

echo Done. nasher.cfg created.
pause


REM @echo off
REM setlocal enabledelayedexpansion

REM set OUTPUT=nasher.cfg

REM (
REM echo [package]
REM echo name = "Package Name"
REM echo description = "Package Description"
REM echo version = "1.01prc8"
REM echo url = ""
REM echo author = "Original Author"
REM echo author = ""
REM echo.
REM echo   [package.sources]
REM echo   include = "src/module/**/*.{nss.json}"
REM echo   include = "src/include/**/*.{nss}"
REM echo.
REM echo   [package.rules]
REM echo   "*" = "src/module/$ext"
REM echo.
REM ) > %OUTPUT%

REM for %%f in (*.hak) do (
    REM set NAME=%%~nf

    REM (
    REM echo [target]
    REM echo name = "!NAME!"
    REM echo file = "%%~nxf"
    REM echo group = "haks"
    REM echo description = "Auto-generated target for !NAME!"
    REM echo     [target.sources]
    REM echo         include = "src/hakpak/!NAME!/**/*"
    REM echo.
    REM echo     [target.rules]
    REM echo         "*" = "src/hakpak/!NAME!/$ext"
    REM echo.
    REM ) >> %OUTPUT%
REM )

REM echo Done. nasher.cfg created.
REM pause