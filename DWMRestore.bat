@echo off

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%ERRORLEVEL%' NEQ '0' goto noadmin

echo So you want DWM back eh?
echo Well this file is for you.
echo .
echo THIS WILL LOG YOU OUT SO SAVE ALL YOUR STUFF!
pause

echo.
echo Do you want to enable single step mode? (This will pause after each operation)
set /P singlestep=Type yes for yes, anything else for no: 

cls
echo Resetting shell to explorer.exe.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d explorer.exe /f

if %singlestep%==yes pause

echo Moving files back
move %USERPROFILE%\Documents\backup\dlls\* %WINDIR%\System32
move %USERPROFILE%\Documents\backup\exes\* %WINDIR%\System32

if %singlestep%==yes pause

if not exist C:\Windows\SystemResources\Windows.UI.TaskManager (
	echo Disabling extra fixes
	reg delete HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2} /f
	reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /f
	move %USERPROFILE%\Documents\backup\Windows.UI.TaskManager C:\Windows\SystemResources
	icacls C:\Windows\SystemResources /restore %USERPROFILE%\Documents\backup\acls\TaskManagerExtra.acl
	if exist C:\Windows\SystemResources\Windows.UI.TaskManager (
	 del %USERPROFILE%\Documents\backup\acls\TaskManagerExtra.acl
	) else (
	 echo Could not restore task manager. Please do so manually or run sfc /scannow.
	)
)

echo Restoring ownership
for %%F in (
  dwminit.dll
  Windows.UI.Logon.dll
  sihost.exe
  dwm.exe
  ) do icacls %WINDIR%\System32\%%F /setowner "NT SERVICE\TrustedInstaller"

if %singlestep%==yes pause

echo Restoring ACLs
for %%A in (%USERPROFILE%\Documents\backup\acls\*) do icacls %WINDIR%\System32 /restore %%A

if %singlestep%==yes pause

echo Removing backup folder
rmdir %USERPROFILE%\Documents\backup /s /q

if %singlestep%==yes pause

echo Logging off
logoff

:noadmin
echo You must run this script as administrator.
pause