@echo off
setlocal
title KiroDemo - local web server
cd /d "%~dp0frontend" || goto :missing
if not exist "index.html" goto :missing
if not exist "policies.json" goto :missing
set "runtime=C:\Program Files\WindowsApps\OpenAI.CodexPrimaryRuntime.v26-1117-835-0_26.1117.835.0_x64__3k8sg7r9htsxt\dependencies\python\python.exe"
if exist "%runtime%" goto :serve
python -c "import http.server" >nul 2>&1
if errorlevel 1 goto :missing
set "runtime=python"
:serve
echo Leave this window open while using the demo. Close it to stop the server.
"%runtime%" -B -c "from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler; import webbrowser; server = ThreadingHTTPServer(('127.0.0.1', 0), SimpleHTTPRequestHandler); url = 'http://127.0.0.1:' + str(server.server_port) + '/'; print(url, flush=True); webbrowser.open(url); server.serve_forever()"
if errorlevel 1 pause
exit /b
:missing
echo Could not find the frontend folder or Python runtime.
pause
exit /b 1
