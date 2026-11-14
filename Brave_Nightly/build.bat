@echo off
setlocal
cd /d "%~dp0"
where go >nul 2>nul || (echo Go is not installed. Get it from https://go.dev/dl/ & exit /b 1)

echo [1/4] Fetching dependencies...
go mod tidy || exit /b 1

echo [2/4] Embedding icon and manifest...
go run github.com/akavel/rsrc@v0.10.2 -arch amd64 -manifest app.manifest -ico icon.ico -o rsrc_windows_amd64.syso || exit /b 1

if not exist dist mkdir dist
set GOOS=windows
set GOARCH=amd64

echo [3/4] Building release exe (no console window)...
go build -trimpath -ldflags "-s -w -H windowsgui" -o dist\brave-nightly-portable.exe . || exit /b 1

echo [4/4] Building console/debug exe...
go build -trimpath -o dist\brave-nightly-portable-debug.exe . || exit /b 1

echo.
echo Done. Copy dist\brave-nightly-portable.exe to an empty folder on your USB drive and run it.
echo Use the -debug exe from a terminal to see live logs: brave-nightly-portable-debug.exe install
endlocal
