# pvm

The seamless Python Version Manager for Windows!

by viki

windviki@gmail.com

Notes:

1. Put this script in any path which does not contain a python.exe
   
2. Open a Powershell session, run this command to change your Powershell execution policy:

   `Set-ExecutionPolicy RemoteSigned`

3. Double-click on run this python.ps1
   
4. OK. All of your python versions found in Env::Path are configurated. You can found the configuration file in 

   `C:\Users\<UserName>\pvm.json`

5. Feel free to edit this file to add/remove/rename python versions.

6. From now on, you can specify version to the python commands like:

    `python -3.8.1 example.py`

    `python -2.7.18 example.py`

    `python :conda2 example.py`
