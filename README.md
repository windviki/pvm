# pvm

The seamless Python Version Manager for Windows!

by viki

windviki@gmail.com

Notes:

1. Put this script in any path which does not contain a python.exe
   
2. Open a Powershell session, run this command to change your Powershell execution policy:

   `Set-ExecutionPolicy RemoteSigned`

3. Make sure the .ps1 file is associated with Powershell.exe. Use "Open with ..." menu to change it if it's not.
   
4. Make sure .ps1 is in your **System** Environment Variable **PATHEXT**. So we can execute python.ps1 file after initialization, without typing extension.
   
5. Double-click on this python.ps1 to run the automatic configuration initialization.
   
6. OK. All of your python versions found in Env::Path are configurated. You can found the configuration file in 

   `C:\Users\<UserName>\pvm.json`

7. Feel free to edit this file to add/remove/rename python versions.

8. From now on, you can specify version to the python commands like:

    `python -3.8.1 example.py`

    `python -2.7.18 example.py`

    `python :conda2 example.py`

   And you can use it without version hint so that it will use the last (or the default) vesion automatically.
   