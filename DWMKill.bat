@echo off

color 4

echo ~~~~ WARNING! ~~~~
echo This program modifies system files and kills system 
echo processes in order to do it's job. Any usage of this
echo program is at your own risk and I am not responsible
echo for any damages that might be caused to your system
echo or to your personal files. 
echo 
echo While I try to make this program work in every
echo situation and cause as little damage as possible,
echo this program might still cause issues on unsupported systems.
echo 
echo Tested on Windows 11 22H2.

pause

echo THIS WILL CRASH YOUR SESSION SO SAVE ALL YOUR DATA BEFOREHAND!

pause

color 7
cls

echo Setting windows shell to cmd.exe
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d cmd.exe /f

cd %WINDIR%\system32
mkdir %USERPROFILE%\Documents\backup
mkdir %USERPROFILE%\Documents\backup\dlls
mkdir %USERPROFILE%\Documents\backup\exes

echo Saving ACLs (permissions) of files
icacls dwmcore.dll /save %USERPROFILE%\Documents\backup\acls\dwmcore.dll.acl
icacls dwmapi.dll /save %USERPROFILE%\Documents\backup\acls\dwmapi.dll.acl
icacls dwmredir.dll /save %USERPROFILE%\Documents\backup\acls\dwmredir.dll.acl
icacls dwmscene.dll /save %USERPROFILE%\Documents\backup\acls\dwmscene.dll.acl
icacls dwmghost.dll /save %USERPROFILE%\Documents\backup\acls\dwmghost.dll.acl
icacls dwminit.dll /save %USERPROFILE%\Documents\backup\acls\dwminit.dll.acl
icacls Windows.UI.Logon.dll /save %USERPROFILE%\Documents\backup\acls\Windows.UI.Logon.dll.acl

icacls dwm.exe /save %USERPROFILE%\Documents\backup\acls\dwm.exe.acl
icacls sihost.exe /save %USERPROFILE%\Documents\backup\acls\sihost.exe.acl

echo Taking over files
takeown /f dwmcore.dll        
takeown /f dwmapi.dll         
takeown /f dwmredir.dll       
takeown /f dwmscene.dll       
takeown /f dwmghost.dll       
takeown /f dwminit.dll        
takeown /f Windows.UI.Logon.dll

takeown /f dwm.exe            
takeown /f sihost.exe 		

echo Modifying file permissions
icacls dwmcore.dll /grant %USERNAME%:F
icacls dwmapi.dll /grant %USERNAME%:F
icacls dwmredir.dll /grant %USERNAME%:F
icacls dwmscene.dll /grant %USERNAME%:F
icacls dwmghost.dll /grant %USERNAME%:F
icacls dwminit.dll /grant %USERNAME%:F
icacls Windows.UI.Logon.dll /grant %USERNAME%:F

icacls dwm.exe /grant %USERNAME%:F
icacls sihost.exe /grant %USERNAME%:F

echo Suspending winlogon so it doesn't restart dwm.exe
%USERPROFILE%\Downloads\PSTools\pssuspend64.exe /accepteula winlogon.exe

echo Killing problematic processes (theyre twitter users)
%USERPROFILE%\Downloads\PSTools\pskill64.exe /accepteula explorer.exe
%USERPROFILE%\Downloads\PSTools\pskill64.exe /accepteula sihost.exe
%USERPROFILE%\Downloads\PSTools\pskill64.exe /accepteula dwm.exe

echo Moving files to backup location
move dwmcore.dll              %USERPROFILE%\Documents\backup\dlls
move dwmapi.dll               %USERPROFILE%\Documents\backup\dlls
move dwmredir.dll             %USERPROFILE%\Documents\backup\dlls
move dwmscene.dll             %USERPROFILE%\Documents\backup\dlls
move dwmghost.dll             %USERPROFILE%\Documents\backup\dlls
move dwminit.dll              %USERPROFILE%\Documents\backup\dlls
move Windows.UI.Logon.dll     %USERPROFILE%\Documents\backup\dlls

move dwm.exe                  %USERPROFILE%\Documents\backup\exes
move sihost.exe 			  %USERPROFILE%\Documents\backup\exes

echo Resuming winlogon
%USERPROFILE%\Downloads\PSTools\pssuspend64.exe /accepteula -r winlogon.exe