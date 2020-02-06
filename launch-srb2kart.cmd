@echo off

REM Kurzov's Command-Line SRB2Kart Launcher
REM Launcher Copyright (C)      2020 by James 'Kurzov' Mills
REM SRB2Kart Copyright (C) 1998-2018 by Kart Krew and Sonic Team Junior
REM HashDeep is a Public Domain program
REM INI file processing code from Batchography book, written by Elias Bachaalany
REM THIS PROGRAM COMES WITH NO WARRANTY, BE IT IMPLIED OR EXPLICIT. USE AT YOUR OWN RISK.



:main
  @echo off
  setlocal enabledelayedexpansion
  cd "%~dp0"
  mkdir logs
  REM For determining versions when doing hash-checking
  set vanillahash=VANILLA
  set fkarthash=FKART
  set battlehash=BATTLE
  set shaderhash=SHADER
  REM End hash-checking placeholder names
  set scriptlocation=%~dp0
  set launcherlogging=%~dp0logs
  set temporaryhashstorage=%~dp0logs\tempkarthash.txt
  
  echo CONFIGURATION CHECK
  call :get-ini kartlauncher.ini LAUNCHER CHECK-WORKING-DIRECTORIES cwd-enabled
  if %cwd-enabled%==0 echo Search mode is: [LEGACY] OPTION FILE. Consider using CHECK-WORKING-DIRECTORIES=2.
  if %cwd-enabled%==1 echo Search mode is: [LEGACY] HARDCODED LOOKUP. Consider using CHECK-WORKING-DIRECTORIES=2.
  if %cwd-enabled%==2 echo Search mode is: ENUMERATION.
  if not exist %scriptlocation%\hashdeep.exe if %cwd-enabled%==2 goto hashdeep-missing
  call :get-ini kartlauncher.ini LAUNCHER 32-BIT-DIR x32bitdir
  echo 32-bit (x86) working directory is %x32bitdir%
  call :get-ini kartlauncher.ini LAUNCHER 64-BIT-DIR x64bitdir
  echo 64-bit (x64) working directory is %x64bitdir%
  if %cwd-enabled%==2 goto newsearch
  
  call :get-ini kartlauncher.ini LAUNCHER VANILLA-X86-PATH vanilla32
  if %cwd-enabled%==1 if "%vanilla32%"=="" echo 32-bit Kart install not found, checking 32-bit working directory...
  if %cwd-enabled%==0 if "%vanilla32%"=="" echo 32-bit Kart install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2KART.EXE set vanilla32=%x32bitdir%\SRB2KART.EXE
  if %cwd-enabled%==1 if "%vanilla32%"=="" echo 32-bit Kart install still not found
  if not "%vanilla32%"=="" echo 32-bit Kart install is located at %vanilla32%
  
  call :get-ini kartlauncher.ini LAUNCHER VANILLA-X64-PATH vanilla64
  if %cwd-enabled%==1 if "%vanilla64%"=="" echo 64-bit Kart install not found, checking 64-bit working directory...
  if %cwd-enabled%==0 if "%vanilla64%"=="" echo 64-bit Kart install not found
  if %cwd-enabled%==1 if exist %x64bitdir%\SRB2KART.EXE set vanilla64=%x64bitdir%\SRB2KART.EXE
  if %cwd-enabled%==1 if "%vanilla64%"=="" echo 64-bit Kart install still not found
  if not "%vanilla64%"=="" echo 64-bit Kart install is located at %vanilla64%
  
  call :get-ini kartlauncher.ini LAUNCHER FKART-X86-PATH fickart32
  if %cwd-enabled%==1 if "%fickart32-reg%"=="" echo 32-bit FKart install not found, checking 32-bit working directory...
  if %cwd-enabled%==0 if "%fickart32-reg%"=="" echo 32-bit FKart install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2FKART.EXE set fickart32-reg=%x32bitdir%\SRB2FKART.EXE
  if %cwd-enabled%==1 if "%fickart32-reg%"=="" echo 32-bit FKart install still not found
  if not "%fickart32-reg%"=="" echo 32-bit FKart install is located at %fickart32-reg%
  
  call :get-ini kartlauncher.ini LAUNCHER FKART-X64-PATH fickart64
  if %cwd-enabled%==1 if "%fickart64%"=="" echo 64-bit FKart install not found, checking 64-bit working directory...
  if %cwd-enabled%==0 if "%fickart64%"=="" echo 64-bit FKart install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2FKART.EXE set fickart64=%x64bitdir%\SRB2FKART.EXE
  if %cwd-enabled%==1 if "%fickart64%"=="" echo 64-bit FKart install still not found
  if not "%fickart64%"=="" echo 64-bit FKart install is located at %fickart64%
  
  call :get-ini kartlauncher.ini LAUNCHER SHADERFIX-X86-PATH shaders32
  if %cwd-enabled%==1 if "%shaders32%"=="" echo 32-bit Shader Fix install not found, checking 32-bit working directory...
  if %cwd-enabled%==0 if "%shaders32%"=="" echo 32-bit Shader Fix install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2KART-SHADERS.EXE set shaders32=%x32bitdir%\SRB2KART-SHADERS.EXE
  if %cwd-enabled%==1 if "%shaders32%"=="" echo 32-bit Shader Fix install still not found
  if not "%shaders32%"=="" echo 32-bit Shader Fix install is located at %shaders32%
  
  call :get-ini kartlauncher.ini LAUNCHER SHADERFIX-X64-PATH shaders64
  if %cwd-enabled%==1 if "%shaders64%"=="" echo 64-bit Shader Fix install not found, checking 64-bit working directory...
  if %cwd-enabled%==0 if "%shaders64%"=="" echo 64-bit Shader Fix install not found
  if %cwd-enabled%==1 if exist %x64bitdir%\SRB2KART-SHADERS.EXE set shaders64=%x64bitdir%\SRB2KART-SHADERS.EXE
  if %cwd-enabled%==1 if "%shaders64%"=="" echo 64-bit Shader Fix install still not found
  if not "%shaders64%"=="" echo 64-bit Shader Fix install is located at %shaders64%
  
  call :get-ini kartlauncher.ini LAUNCHER BATTLEROYALE-X86-PATH fornite32
  if %cwd-enabled%==1 if "%fornite32%"=="" echo 32-bit Battle Royale install not found, checking 32-bit working directory...
  if %cwd-enabled%==0 if "%fornite32%"=="" echo 32-bit Battle Royale install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2KART-BATTLEROYALE.EXE set fornite32=%x32bitdir%\SRB2KART-BATTLEROYALE.EXE
  if %cwd-enabled%==1 if "%fornite32%"=="" echo 32-bit Battle Royale install still not found
  if not "%fornite32%"=="" echo 32-bit Battle Royale install is located at %fornite32%
  
  call :get-ini kartlauncher.ini LAUNCHER BATTLEROYALE-X64-PATH fornite64
  if %cwd-enabled%==1 if "%fornite64%"=="" echo 64-bit Battle Royale install not found, checking 64 -bit working directory...
  if %cwd-enabled%==0 if "%fornite64%"=="" echo 64-bit Battle Royale install not found
  if %cwd-enabled%==1 if exist %x64bitdir%\SRB2KART-BATTLEROYALE.EXE set fornite64=%x64bitdir%\SRB2KART-BATTLEROYALE.EXE
  if %cwd-enabled%==1 if "%fornite64%"=="" echo 64-bit Battle Royale install still not found
  if not "%fornite64%"=="" echo 64-bit Battle Royale install is located at %fornite64%
  :notice
  choice /N /T 5 /D Y /M "Is this okay?"
  REM cls
  call :get-ini kartlauncher.ini LAUNCHER HYUUSEEKER-ENABLED hs-enabled
                     echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if %hs-enabled%==0 echo                 NOTICE - Experimental HyuuSeeker support is DISABLED!!
  if %hs-enabled%==1 echo                 NOTICE - Experimental HyuuSeeker support is  ENABLED!!
                     echo THIS PROGRAM COMES WITH NO WARRANTY, BE IT IMPLIED OR EXPLICIT. USE AT YOUR OWN RISK.
                     echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  pause
  REM todo: ADD CUSTOM .EXE SUPPORT AT SOME POINT
  cls
  @echo off
  REM change to @echo on to enable debug logging
  :menu
  echo [KURZOV'S SRB2KART COMMAND LINE LAUNCHER]
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if not "%vanilla32%"=="" echo 1: Vanilla, 32-bit
  if not "%vanilla64%"=="" echo 2: Vanilla, 64-bit
  if not "%fickart32-reg%"=="" echo 3: FKart, 32-bit
  if not "%fickart64-reg%"=="" echo 4: FKart, 64-bit
  if not "%shaders32%"=="" echo 5: Shader Fix, 32-bit
  if not "%shaders64%"=="" echo 6: Shader Fix, 64-bit
  if not "%fornite32%"=="" echo 7: Battle Royale, 32-bit
  if not "%fornite64%"=="" echo 8: Battle Royale, 64-bit
  if not "%fickart32-sdr%"=="" echo 9: FKart with Shaders, 32-bit
  if not "%fickart32-bry%"=="" echo A: FKart with Battle Royale, 32-bit
  if not "%fickart64-sdr%"=="" echo B: FKart with Shaders, 32-bit
  if not "%fickart64-bry%"=="" echo C: FKart with Battle Royale, 64-bit
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if "%lsfunction%"=="" choice /C:123456789ABCZ /N /M "Choose an executable from the above list, or press Z to stop this program."
  if "%lsfunction%"=="1" choice /C:123456789ABCZ /N /M "Choose an executable from the above list, or press Z to stop this program. You may need to press Z more than once to completely halt the script."
  if ERRORLEVEL 13 GOTO leave
  if ERRORLEVEL 12 GOTO fkart-bry32
  if ERRORLEVEL 11 GOTO fkart-sdr32
  if ERRORLEVEL 10 GOTO fkart-bry32
  if ERRORLEVEL 9 GOTO fkart-sdr32
  if ERRORLEVEL 8 GOTO br64
  if ERRORLEVEL 7 GOTO br32
  if ERRORLEVEL 6 GOTO shader64
  if ERRORLEVEL 5 GOTO shader32
  if ERRORLEVEL 4 GOTO fkart64
  if ERRORLEVEL 3 GOTO fkart32
  if ERRORLEVEL 2 GOTO vanilla64
  if ERRORLEVEL 1 GOTO vanilla32
  
  REM todo: make the following section a bit less stupid
  REM todo: ADD HYUUSEEKER INTEGRATION AT SOME POINT
  
  
  
REM ---------------- VANILLA 32 BIT --------------------------------------------
  :vanilla32
  cls
  echo VANILLA, 32-BIT
  call :lastserver vanilla32
  goto menu
  
  :vanilla32-direct
  echo [DEBUG] vanilla32direct
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %vanilla32% -connect %lastserver%
  if ERRORLEVEL == 1 %vanilla32% -openGL -connect %lastserver%
  goto menu
  
  :vanilla32-indirect
  echo [DEBUG] vanilla32indirect
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %vanilla32% 
  if ERRORLEVEL == 1 %vanilla32% -openGL
  goto menu
REM ----------------------- VANILLA 64 BIT -----------------------------------
  :vanilla64
  cls
  echo VANILLA, 64-BIT
  call :lastserver vanilla64
  goto menu
  
  :vanilla64-direct
  echo [DEBUG] vanilla64direct
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %vanilla64% -connect %lastserver%
  if ERRORLEVEL == 1 %vanilla64% -openGL -connect %lastserver%
  goto menu	
  
  :vanilla64-indirect
  echo [DEBUG] vanilla64indirect
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %vanilla64%
  if ERRORLEVEL == 1 %vanilla64% -openGL
  goto menu
REM ------------------------- FICKLE KART 32 BIT --------------------------
  :fkart32
  cls
  echo FICKLEKART (FKART), 32-BIT
  call :lastserver fkart32
  goto menu
  
  :fkart32-direct
  echo [DEBUG] ficklekart32direct
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart32-reg% -connect %lastserver%
  if ERRORLEVEL == 1 %fickart32-reg% -openGL -connect %lastserver%
  goto menu
  
  :fkart32-indirect
  echo [DEBUG] ficklekart32indirect
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart32-reg% 
  if ERRORLEVEL == 1 %fickart32-reg% -openGL
  goto menu
REM ----------------------- FICKLE KART 64 BIT -----------------------------
  :fkart64
  cls
  echo FICKLEKART (FKART), 64-BIT
  call :lastserver fkart64
  goto menu
  
  :fkart64-direct
  echo [DEBUG] ficklekart64direct
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart64-reg% -connect %lastserver%
  if ERRORLEVEL == 1 %fickart64-reg% -openGL -connect %lastserver%
  goto menu
  
  :fkart64-indirect
  echo [DEBUG] ficklekart64indirect
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart64-reg% 
  if ERRORLEVEL == 1 %fickart64-reg% -openGL
  goto menu
  
REM ------------------------- SHADER FIX 32 BIT --------------------------
  :shader32
  cls
  echo SHADER FIX, 32-BIT
  call :lastserver shader32
  goto menu
  
  :shader32-direct
  echo [DEBUG] shaderfix32direct
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %shaders32% -connect %lastserver%
  if ERRORLEVEL == 1 %shaders32% -openGL -connect %lastserver%
  goto menu
  
  :shader32-indirect
  echo [DEBUG] shaderfix32indirect
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %shaders32% 
  if ERRORLEVEL == 1 %shaders32% -openGL
  goto menu
REM --------------------- SHADER FIX 64 BIT ------------------------------  
  :shader64
  cls
  echo SHADER FIX, 64-BIT
  call :lastserver shader64
  goto menu

  :shader64-direct
  echo [DEBUG] shaderfix64direct
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %shaders64% -connect %lastserver%
  if ERRORLEVEL == 1 %shaders64% -openGL -connect %lastserver%
  goto menu
  
  :shader64-indirect
  echo [DEBUG] shaderfix64indirect
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %shaders64% 
  if ERRORLEVEL == 1 %shaders64% -openGL
  goto menu
REM ------------------ BATTLE ROYALE 32 BIT -----------------------------  
  :br32
  cls
  echo BATTLE ROYALE, 32-BIT
  call :lastserver br32
  goto menu

  :br32-direct
  echo [DEBUG] battleroyale32direct
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fornite32% -connect %lastserver%
  if ERRORLEVEL == 1 %fornite32% -openGL -connect %lastserver%
  goto menu
  
  :br32-indirect
  echo [DEBUG] battleroyale32indirect
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fornite32% 
  if ERRORLEVEL == 1 %fornite32% -openGL
  goto menu 
REM ---------------- BATTLE ROYALE 64 BIT -----------------------------------  
  :br64
  cls
  echo BATTLE ROYALE, 64-BIT
  call :lastserver br64
  goto menu

  :br64-direct
  echo [DEBUG] battleroyale64direct
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fornite64% -connect %lastserver%
  if ERRORLEVEL == 1 %fornite64% -openGL -connect %lastserver%
  goto menu
  
  :br64-indirect
  echo [DEBUG] battleroyale64indirect
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fornite64% 
  if ERRORLEVEL == 1 %fornite64% -openGL
  goto menu 
REM -------------- FKART PLUS BATTLE ROYALE 32 BIT --------------
  :fkart-bry32
  cls
  echo FKART PLUS BATTLE ROYALE, 32 BIT
  call :lastserver fkart-bry32
  goto menu
  
  :fkart-bry32-direct
  echo [DEBUG] ficklekartbry32direct
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart32-bry% -connect %lastserver%
  if ERRORLEVEL == 1 %fickart32-bry% -openGL -connect %lastserver%
  goto menu
  
  :fkart-bry32-indirect
  echo [DEBUG] ficklekartbry32indirect
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart32-bry% 
  if ERRORLEVEL == 1 %fickart32-bry% -openGL
  goto menu
REM -------------- FKART PLUS SHADERS 32 BIT --------------
  :fkart-sdr32
  cls
  echo FKART PLUS SHADERS, 32 BIT
  call :lastserver fkart-sdr32
  goto menu
  
  :fkart-sdr32-direct
  echo [DEBUG] ficklekartsdr32direct
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart32-sdr% -connect %lastserver%
  if ERRORLEVEL == 1 %fickart32-sdr% -openGL -connect %lastserver%
  goto menu
  
  :fkart-sdr32-indirect
  echo [DEBUG] ficklekartsdr32indirect
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart32-sdr% 
  if ERRORLEVEL == 1 %fickart32-sdr% -openGL
  goto menu
REM -------------- FKART PLUS BATTLE ROYALE 64 BIT --------------  
  :fkart-bry64
  REM idk if this even exists right now but just for posterity
  cls
  echo FKART PLUS BATTLE ROYALE, 64 BIT
  call :lastserver fkart-bry64
  goto menu
  
  :fkart-bry64-direct
  echo [DEBUG] ficklekartbry64direct
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart64-bry% -connect %lastserver%
  if ERRORLEVEL == 1 %fickart64-bry% -openGL -connect %lastserver%
  goto menu
  
  :fkart-bry64-indirect
  echo [DEBUG] ficklekartbry64indirect
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart64-bry% 
  if ERRORLEVEL == 1 %fickart64-bry% -openGL
  goto menu
REM -------------- FKART PLUS SHADERS 64 BIT --------------
  :fkart-sdr64
  cls
  echo FKART PLUS SHADERS, 64 BIT
  call :lastserver fkart-sdr64
  goto menu
  
  :fkart-sdr64-direct
  echo [DEBUG] ficklekartsdr64direct
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart64-sdr% -connect %lastserver%
  if ERRORLEVEL == 1 %fickart64-sdr% -openGL -connect %lastserver%
  goto menu
  
  :fkart-sdr64-indirect
  echo [DEBUG] ficklekartsdr64indirect
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart64-sdr% 
  if ERRORLEVEL == 1 %fickart64-sdr% -openGL
  goto menu
  
REM Supporting Elements (the INI reader, """""Last Server""""" implementation, etc.)

:hashdeep-missing
cls
echo Hashdeep is required to use the Command Line Interface with the search mode set to ENUMERATION. You can obtain it at http://md5deep.sourceforge.net/ - aborting program
pause
exit /B 1

:get-ini <filename> <section> <key> <result>
  set %~4=
  setlocal
  set insection=
  for /f "usebackq eol=; tokens=*" %%a in ("%~1") do (
    set line=%%a
    if defined insection (
      for /f "tokens=1,* delims==" %%b in ("!line!") do (
        if /i "%%b"=="%3" (
          endlocal
          set %~4=%%c
          goto :eof
        )
      )
    )
    if "!line:~0,1!"=="[" (
      for /f "delims=[]" %%b in ("!line!") do (
        if /i "%%b"=="%2" (
          set insection=1
        ) else (
          endlocal
          if defined insection goto :eof
        )
      )
    )
  )
  endlocal
  
:lastserver <version>
	set lsfunction=1
  	echo If you would like to directly connect to a server, input its IP or web address here. (ex. tohru.is-very-cute.moe, 173.92.19.113, or tyronesama.moe)
  	set /p lastserver="Input a server IP address or just press ENTER to continue without directly connecting. "
  	if "%lastserver%"=="" goto %1-indirect
  	if not "%lastserver%"=="" goto %1-direct
  endlocal
  
:newsearch
set X32BUILDNUMBER=0
pause
FOR /F "tokens=*" %%G IN ('DIR/B /S %x32bitdir%\*.exe') DO (
	set /a X32BUILDNUMBER+=1
	set TEMP_PATH_HOLDER=%%G
	md5deep -W %launcherlogging%\md5deepoutput.txt %%G 
	set TEMP_CHKSM_HOLDER < %launcherlogging%\md5deepoutput.txt
	set TEMP_SHORT_CHKSM_HOLDER=%TEMP_CHKSM_HOLDER:~0,32%
	IF %TEMP_SHORT_CHKSM_HOLDER%=="65d0acd26180a9b3d784c889a199900f" call :assign_build_info vanilla 1.1.0 05-29-2019 none %X32BUILDNUMBER%
	IF "%TEMP_SHORT_CHKSM_HOLDER%"=="193f84f62ecfc3942b5b111641fdc2d5" call :assign_build_info vanilla 1.1.0 12-21-2019 fortnite %X32BUILDNUMBER%
	
	
	
)
pause
REM TODO: identify *specific* builds (e.g. vanilla v1.0.1) by checksum, 32bit/64bit
goto notice

:assign_build_info <type> <vers> <date> <scrm> <buildnum>
	set KART-32BUILD-[!X32BUILDNUMBER!]-TYPE=%1
	set KART-32BUILD-[!X32BUILDNUMBER!]-VERS=%2
	set KART-32BUILD-[!X32BUILDNUMBER!]-DATE=%3
	set KART-32BUILD-[!X32BUILDNUMBER!]-SRCM=%4
goto :eof

:get_build_info <buildnum>
	echo Build Type: %KART-32BUILD-!X32BUILDNUMBER!]-TYPE%
	echo Build Vers: %KART-32BUILD-!X32BUILDNUMBER!]-VERS%
	echo Build Date: %KART-32BUILD-!X32BUILDNUMBER!]-DATE%
	echo Build Srcm: %KART-32BUILD-!X32BUILDNUMBER!]-SRCM%
goto :eof

:leave
set buildIndex=0
exit /B 0