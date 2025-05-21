# DWMScripts
Scripts to disable and enable dwm at will.

# How to install
1. Download PSTools from [here](https://learn.microsoft.com/en-us/sysinternals/downloads/pstools) and extract, then give it the folder location when you're prompted.
2. Run the DWMKill.bat script as Administrator.
3. Read the warning.
4. ...
5. Profit

# How to uninstall
1. Open control panel (control.exe)
2. Go to a path in the filesystem
3. Find cmd.exe or create a shortcut to it
4. Run cmd as administrator and navigate to the path of the scripts
5. Run DWMRestore.bat
6. ...
7. Profit

# Recovery Restore
This mode is specifically if your PC restarted and no longer boots up. The only issue with this is that it doesn't restore any of the file permissions and as such you'll have to run DWMRestore.bat again either way.

1. In recovery go to Command Prompt under Advanced Recovery Options
2. Change directory to the path where the scripts are
3. Answer what the script has to say
4. Reboot back into Windows
5. Follow the steps on "How to uninstall"