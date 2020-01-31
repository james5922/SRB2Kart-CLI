@echo off

REM Kurzov's Command-Line SRB2Kart Launcher
REM Launcher Copyright (C)      2020 by James 'Kurzov' Mills
REM SRB2Kart Copyright (C) 1998-2018 by Kart Krew and Sonic Team Junior
REM INI file processing code from Batchography book, written by Elias Bachaalany
REM THIS PROGRAM COMES WITH NO WARRANTY, BE IT IMPLIED OR EXPLICIT. USE AT YOUR OWN RISK.



:main
  @echo off
  cls
  echo CONFIGURATION CHECK
  setlocal enabledelayedexpansion
  call :get-ini kartlauncher.ini LAUNCHER CHECK-WORKING-DIRECTORIES cwd-enabled
  if %cwd-enabled%==0 echo Automatic searching of working directories for SRB2Kart executables is: DISABLED.
  if %cwd-enabled%==1 echo Automatic searching of working directories for SRB2Kart executables is:  ENABLED.
  call :get-ini kartlauncher.ini LAUNCHER 32-BIT-DIR x32bitdir
  echo 32-bit (x86) working directory is %x32bitdir%
  call :get-ini kartlauncher.ini LAUNCHER 64-BIT-DIR x64bitdir
  echo 64-bit (x64) working directory is %x64bitdir%
  
  call :get-ini kartlauncher.ini LAUNCHER VANILLA-X86-PATH vanilla32
  if %cwd-enabled%==1 if "%vanilla32%"=="" echo 32-bit Kart install not found, checking 32-bit working directory...
  if %cwd-enabled%==0 if "%vanilla32%"=="" echo 32-bit Kart install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2KART.EXE set vanilla32=%x32bitdir%\SRB2KART.EXE
  if %cwd-enabled%==1 if "%vanilla32%"=="" echo 32-bit Kart install still not found
  if not "%vanilla32%"=="" echo 32-bit Kart install is located at %vanilla32%
  
  call :get-ini kartlauncher.ini LAUNCHER VANILLA-X64-PATH vanilla64
  if "%vanilla64%"=="" echo 64-bit Kart install not found
  if not "%vanilla64%"=="" echo 64-bit Kart install is located at %vanilla64%
  
  call :get-ini kartlauncher.ini LAUNCHER FKART-X86-PATH fickart32
  if %cwd-enabled%==1 if "%fickart32%"=="" echo 32-bit FKart install not found, checking 32-bit working directory...
  if %cwd-enabled%==0 if "%fickart32%"=="" echo 32-bit FKart install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2FKART.EXE set fickart32=%x32bitdir%\SRB2FKART.EXE
  if %cwd-enabled%==1 if "%fickart32%"=="" echo 32-bit FKart install still not found
  if not "%fickart32%"=="" echo 32-bit FKart install is located at %fickart32%
  
  call :get-ini kartlauncher.ini LAUNCHER FKART-X64-PATH fickart64
  if "%fickart64%"=="" echo 64-bit FKart install not found
  if not "%fickart64%"=="" echo 64-bit FKart install is located at %fickart64%
  
  call :get-ini kartlauncher.ini LAUNCHER SHADERFIX-X86-PATH shaders32
  if %cwd-enabled%==1 if "%shaders32%"=="" echo 32-bit Shader Fix install not found, checking 32-bit working directory...
  if %cwd-enabled%==0 if "%shaders32%"=="" echo 32-bit Shader Fix install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2KART-SHADERS.EXE set shaders32=%x32bitdir%\SRB2KART-SHADERS.EXE
  if %cwd-enabled%==1 if "%shaders32%"=="" echo 32-bit Shader Fix install still not found
  if not "%shaders32%"=="" echo 32-bit Shader Fix install is located at %shaders32%
  
  call :get-ini kartlauncher.ini LAUNCHER SHADERFIX-X64-PATH shaders64
  if "%shaders64%"=="" echo 64-bit Shader Fix install not found
  if not "%shaders64%"=="" echo 64-bit Shader Fix install is located at %shaders64%
  
  call :get-ini kartlauncher.ini LAUNCHER BATTLEROYALE-X86-PATH fornite32
  if %cwd-enabled%==1 if "%fornite32%"=="" echo 32-bit Battle Royale install not found, checking 32-bit working directory...
  if %cwd-enabled%==0 if "%fornite32%"=="" echo 32-bit Battle Royale install not found
  if %cwd-enabled%==1 if exist %x32bitdir%\SRB2KART-BATTLEROYALE.EXE set fornite32=%x32bitdir%\SRB2KART-BATTLEROYALE.EXE
  if %cwd-enabled%==1 if "%fornite32%"=="" echo 32-bit Battle Royale install still not found
  if not "%fornite32%"=="" echo 32-bit Battle Royale install is located at %fornite32%
  
  call :get-ini kartlauncher.ini LAUNCHER BATTLEROYALE-X64-PATH fornite64
  if "%fornite64%"=="" echo 64-bit Battle Royale install not found
  if not "%fornite64%"=="" echo 64-bit Battle Royale install is located at %fornite64%
  
  choice /N /T 5 /D Y /M "Is this okay?"
  cls
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
  if not "%fickart32%"=="" echo 3: FKart, 32-bit
  if not "%fickart64%"=="" echo 4: FKart, 64-bit
  if not "%shaders32%"=="" echo 5: Shader Fix, 32-bit
  if not "%shaders64%"=="" echo 6: Shader Fix, 64-bit
  if not "%fornite32%"=="" echo 7: Battle Royale, 32-bit
  if not "%fornite64%"=="" echo 8: Battle Royale, 64-bit
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if "%lsfunction%"=="" choice /C:12345678Z /N /M "Choose an executable from the above list, or press Z to stop this program."
  if "%lsfunction%"=="1" choice /C:12345678Z /N /M "Choose an executable from the above list, or press Z to stop this program. Note: You may need to press Z more than once."
  if ERRORLEVEL 9 GOTO :eof
  if ERRORLEVEL 8 GOTO br64
  if ERRORLEVEL 7 GOTO br32
  if ERRORLEVEL 6 GOTO shader64
  if ERRORLEVEL 5 GOTO shader32
  if ERRORLEVEL 4 GOTO fkart64
  if ERRORLEVEL 3 GOTO fkart32
  if ERRORLEVEL 2 GOTO vanilla64
  if ERRORLEVEL 1 GOTO vanilla32
  
  REM todo: ADD DIRECT CONNECTING TO SERVERS AT SOME POINT
  REM todo: ADD HYUUSEEKER INTEGRATION AT SOME POINT
  REM (HyuuSeeker support will probably be tied to direct connecting to servers)
  
  
  
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
  if ERRORLEVEL == 2 %fickart32% -connect %lastserver%
  if ERRORLEVEL == 1 %fickart32% -openGL -connect %lastserver%
  goto menu
  
  :fkart32-indirect
  echo [DEBUG] ficklekart32indirect
  cd %x32bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart32% 
  if ERRORLEVEL == 1 %fickart32% -openGL
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
  if ERRORLEVEL == 2 %fickart64% -connect %lastserver%
  if ERRORLEVEL == 1 %fickart64% -openGL -connect %lastserver%
  goto menu
  
  :fkart64-indirect
  echo [DEBUG] ficklekart64indirect
  cd %x64bitdir%
  choice /M "Use OpenGL? (Y for OpenGL, N for Software)"
  echo Please wait for the game to start...
  echo WARNING: Window may appear below this console window!!
  echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if ERRORLEVEL == 2 %fickart64% 
  if ERRORLEVEL == 1 %fickart64% -openGL
  goto menu
  
  :shader32
  cls
  echo SHADER FIX, 32-BIT
  pause
  goto :eof
  :shader64
  cls
  echo SHADER FIX, 64-BIT
  pause
  goto :eof
  :br32
  cls
  echo BATTLE ROYALE, 32-BIT
  pause
  goto :eof  
  :br64
  cls
  echo BATTLE ROYALE, 64-BIT
  pause
  goto :eof



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