@ IF '$%CEF_BUILD_DIR%' NEQ '$' GOTO AUTOMATE

@ SET CEF_BUILD_DIR=%~dp0
@ SET GYP_MSVS_VERSION=2015
@ SET GYP_GENERATORS=ninja,msvs-ninja
@ SET CEF_DEPOT_DIR=%CEF_BUILD_DIR%\depot_tools
@ SET PATH=%CEF_DEPOT_DIR%;%CEF_BUILD_DIR%\python276_bin;%PATH%

:AUTOMATE
@ echo 'CEF download and build directory is %CEF_BUILD_DIR%'
@ python automate-git.py --download-dir=%CEF_BUILD_DIR% --branch=2704 %1 %2 %3 %4
@ REM --no-update --no-distrib --x64-build