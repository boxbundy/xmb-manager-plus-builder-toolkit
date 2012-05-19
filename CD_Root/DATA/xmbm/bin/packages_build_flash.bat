@echo off
title Build Flash
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\flash\%id_xmbmp_flash% goto :error_source

:build
call "%bindir%\global_messages.bat" "BUILDING"
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\*.355"') DO (
cd "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile "%~dp0\%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\%%X.rco"
cd "%~dp0"
move "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\%%X" "%pkgsource%\flash\"
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\*.341"') DO (
cd "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile "%~dp0\%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\%%X.rco"
cd "%~dp0"
move "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\%%X" "%pkgsource%\flash\"
)
%external%\%packager% %pkgsource%\package-flash.conf %pkgsource%\flash\%id_xmbmp_flash%
pause
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\flash\*.355"') DO (
move "%pkgsource%\flash\%%X" "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\"
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\flash\*.341"') DO (
move "%pkgsource%\flash\%%X" "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\"
)
del /Q /S "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource\*.rco"
rename UP0001-%id_xmbmp_flash%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Flash.pkg
if not exist "%pkgoutput%" mkdir "%pkgoutput%"
move "%bindir%\*.pkg" "%pkgoutput%\"
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
