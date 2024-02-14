@echo off

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%ERRORLEVEL%' NEQ '0' goto noadmin

color 4

echo ~~~~ WARNING! ~~~~
echo This program modifies system files and kills system 
echo processes in order to do it's job. Any usage of this
echo program is at your own risk and I am not responsible
echo for any damages that might be caused to your system
echo or to your personal files. 
echo. 
echo While I try to make this program work in every
echo situation and cause as little damage as possible,
echo this program might still cause issues on unsupported systems.
echo. 
echo Tested on Windows 11 22H2.

pause

echo THIS WILL CRASH YOUR SESSION SO SAVE ALL YOUR DATA BEFOREHAND!

pause

color 7
cls

:shellselect
echo Put the path to a new shell. Default is cmd.exe
set shell=cmd.exe
set /P shell=Enter path to file: 
if not exist %shell% goto noshell
if exist "%shell%\*" goto noshell
echo Using %shell% as the new windows shell.
echo.

:pstoolsselect
echo Now give the path to where PSTools is located. Default is in your downloads folder.
set pstools=%USERPROFILE%\Downloads\PSTools
set /P pstools=Enter path to directory: 

for %%P in (psexec, pssuspend, pskill) do (
	if not exist %pstools%\%%P.exe goto nopstools
	if not exist %pstools%\%%P64.exe goto nopstools
)

echo Using %pstools% as PSTools directory. Please do not move the folder.
echo.
echo Do you want to enable single step mode? (This will pause after each operation)
set /P singlestep=Type yes for yes, anything else for no: 

echo.
echo Do you want to enable extra fixes for Windows 11? (Disables new task manager, disables new right click menu, disables new explorer look)
set /P extrafixes=Type yes for yes, anything else for no: 

cd %WINDIR%\system32
echo Creating backup folders.
for %%A in (dlls, exes, acls) do mkdir %USERPROFILE%\Documents\backup\%%A

if '%ERRORLEVEL%' NEQ '0' goto nobackup
for %%A in (dlls, exes, acls) do (
  if not exist %USERPROFILE%\Documents\backup\%%A goto nobackup
)

if %singlestep%==yes pause

echo Setting windows shell to %shell% and adding PSExec to always run as admin
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d %shell% /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %pstools%\psexec64.exe /d "~ RUNASADMIN" /f

if %singlestep%==yes pause

if %extrafixes%==yes (
	echo Enabling extra fixes
	reg add HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"/v "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /t REG_SZ /d "" /f

	if %PROCESSOR_ARCHITECTURE%==AMD64 (
		%pstools%\pskill64.exe /accepteula taskmgr.exe
	) else (
		%pstools%\pskill.exe /accepteula taskmgr.exe
	)

	icacls C:\Windows\SystemResources\Windows.UI.TaskManager /save %USERPROFILE%\Documents\backup\acls\TaskManagerExtra.acl /T
	takeown /F C:\Windows\SystemResources\Windows.UI.TaskManager /R
    icacls C:\Windows\SystemResources\Windows.UI.TaskManager /grant %USERNAME%:F /T
	move C:\Windows\SystemResources\Windows.UI.TaskManager %USERPROFILE%\Documents\backup
)

if %singlestep%==yes pause

echo Saving ACLs (permissions) of files, taking over files and modifying file permissions
for %%F in (
  dwminit.dll
  Windows.UI.Logon.dll
  dwm.exe
  sihost.exe 
  ) do icacls %%F /save %USERPROFILE%\Documents\backup\acls\%%F.acl && takeown /f %%F && icacls %%F /grant %USERNAME%:F

if %singlestep%==yes pause

echo Suspending winlogon so it doesn't restart dwm.exe
if %PROCESSOR_ARCHITECTURE%==AMD64 (
  %pstools%\pssuspend64.exe /accepteula winlogon.exe
) else (
  %pstools%\pssuspend.exe /accepteula winlogon.exe
)

if %singlestep%==yes echo The next part involves a race condition, which means that it will do 3 steps all in one go. This is the last pause && pause

echo Killing problematic processes (theyre X users)
for %%X in (
  explorer.exe
  sihost.exe
  dwm.exe
  ) do if %PROCESSOR_ARCHITECTURE%==AMD64 (
    %pstools%\pskill64.exe /accepteula %%X
  ) else (
    %pstools%\pskill.exe /accepteula %%X
  )

echo Moving files to backup location
for %%D in (
  dwminit.dll
  Windows.UI.Logon.dll
  ) do move %%D %USERPROFILE%\Documents\backup\dlls
for %%E in (
  dwm.exe
  sihost.exe
  ) do move %%E %USERPROFILE%\Documents\backup\exes

echo Resuming winlogon
if %PROCESSOR_ARCHITECTURE%==AMD64 (
  %pstools%\pssuspend64.exe /accepteula -r winlogon.exe
) else (
  %pstools%\pssuspend.exe /accepteula -r winlogon.exe
)

:nobackup
echo The backup folder(s)/file(s) has/have not been created or already exist. Aborting!
pause
exit

:noshell
echo The shell you specificed is not valid. Please specify a valid file.
pause
cls
goto shellselect

:nopstools
echo The required PSTools files could not be found. Please specify a location with PSExec, PSKill and PSSuspend.
pause
cls
goto pstoolsselect

:noadmin
echo You must run this script as administrator.
pause
