@echo off

echo You've really screwed up right now, haven't you?
echo Well this file should fix your fuckup.
echo Luckily, in Recovery, we don't need to worry
echo about file permissions.
echo BTW if you're not in recovery, run DWMRestore.bat
echo instead.

pause

echo Fist, give me the drive you installed Windows in
set /P DRIVE=%prompt%

echo Now, give me your user account name.
rem echo No, I will not dox you don't be scared.
rem echo (it's not like I have a way to send it to myself)
set /P SYSTEMUSERNAME=%prompt%

echo Moving files
move %DRIVE%:\Users\%SYSTEMUSERNAME%\Documents\backup\dlls\* %DRIVE%:\Windows\system32
move %DRIVE%:\Users\%SYSTEMUSERNAME%\Documents\backup\exes\* %DRIVE%:\Windows\system32

echo Now I'll reboot ur winpe environment. Goodbye!
wpeutil reboot