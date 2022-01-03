# HZDDowngrader
A bash shell script that downgrades Steam's Horizon Zero Dawn to the 1.10 Hotfix patch. Use this on Linux if you are experiencing graphical errors on the most recent version of Horizon Zero Dawn.

### Running the script
To run this script:
1. Download the code, latest release file, or just the *.sh file.
2. Open a terminal and naviagte to the location that you saved the file.
3. If you installed Horizon Zero Dawn in Steam's default location skip to step 7.
4. Type in `nano HorizonZeroDawnDowngradeScript.sh`.
5. Edit line 4 to read `HORIZON_ZERO_DAWN_DIRECTORY="location/that/you/installed/Horizon Zero Dawn"`.
6. Press `ctrl + X`, `Y`, then `Enter`.
7. Type in `bash HorizonZeroDawnDowngradeScript.sh`.
8. Follow the on-screen instructions from there.

### Restoring Horizon Zero Dawn to the latest version
If you wish to restore Horizon Zero Dawn back to the latest version:
1. Click Settings -> Properties under Horizon Zero Dawn's library page in Steam
2. On the left of the window that appears click Local Files -> Verify integrity of game files...
3. Wait for this process to finish, it may take a few minutes.

*Voilà*, Horizon Zero Dawn is restored to the latest version. 