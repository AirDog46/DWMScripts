# DWMScripts
Scripts to disable and enable dwm at will.

#How to install
<ol>
	<li>Download PSTools from <pst href="https://learn.microsoft.com/en-us/sysinternals/downloads/pstools">here</pst> and extract it in USERPROFILE\Downloads\PSTools. (Do this even if you moved your downloads folder because I hardcoded this crap)</li>
	<li>Run the DWMKill.bat script as Administrator.</li>
	<li>Read the warning.</li>
	<li>...</li>
	<li>Profit</li>
</ol>

#How to uninstall
This might be a little tricky as task manager might be broken due to it becoming a UWP application. However, the script set psexec64 as admin and as such you can use that to restore your system.
<ol>
	<li>Go to the path where pstools is</li>
	<li>Run psexec64.exe cmd.exe</li>
	<li>Click on the invisible Yes button on UAC (it's in the bottom left)</li>
	<li>Go to the path where the scrpts are</li>
	<li>Run DWMRestore.bat</li>
	<li>...</li>
	<li>Profit</li>
</ol>

#Recovery Restore
This mode is specifically if your PC restarted and no longer boots up. The only issue with this is that it doesn't restore any of the file permissions and as such you'll have to run DWMRestore.bat again either way.
<ol>
	<li>In recovery go to Command Prompt under Advanced Recovery Options</li>
	<li>Change directory to the path where the scripts are</li>
	<li>Answer what the script has to say</li>
	<li>Reboot back into Windows</li>
	<li>Follow the steps on "How to uninstall"</li>
</ol>

#Why is the code so garbage?
Cuz I worked for not that long on it and didn't feel like learning how to properly write a script in batch. It could be way better but it does the job. Also cuz these modifications are unsupported and that you'll also need to disable secure mode and a lot of protections for it to work. But hey now you can get 1 more fps in ur fave shooter.