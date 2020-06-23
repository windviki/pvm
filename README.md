# PVM

The seamless Python Version Manager for Windows!

by viki

windviki@gmail.com

## Notes:

1. Checkout this repo into any path which does not contain a python.exe
   
2. Open a Powershell session, run this command to change your Powershell execution policy so that local .ps1 file can be executed:

   `Set-ExecutionPolicy RemoteSigned`

3. Make sure the .ps1 file is associated with Powershell.exe. Use "Open with ..." menu to change it if it isn't.
   
4. Add .ps1 into your **System** Environment Variable **PATHEXT**. So we can execute python.ps1 file after initialization, without typing extension ".ps1".

   `$ echo %PATHEXT%`

   `.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.PS1`
   
5. Double-click on this python.ps1 to run the automatic configuration initialization. If you get a python REPL, it's done.

   ```The script root is D:\research\tools\pvm
   Remove the 'python' alias in user's Env:Path
   This script is not in Env:Path. Initialize the configuration.
   Scan for existing python ...
   Try to execute 'python', please ignore the error messages below this line ...
   Found existing Python path: D:\Python37-64\python.exe
   Found existing Python version:  3.7.6
   Python root is D:\Python37-64
   Remove this python from Machine Env:Path
   Remove this python from User Env:Path
   Try to execute 'python', please ignore the error messages below this line ...
   Found existing Python path: D:\Python383-64\python.exe
   Found existing Python version:  3.8.3
   Python root is D:\Python383-64
   Remove this python from Machine Env:Path
   Remove this python from User Env:Path
   Try to execute 'python', please ignore the error messages below this line ...
   无法将“python”项识别为 cmdlet、函数、脚本文件或可运行程序的名称。请检查名称的拼写，如果包括路径，请确保路径正确，然后
   再试一次。
      + CategoryInfo          : ObjectNotFound: (python:String) [], CommandNotFoundException
      + FullyQualifiedErrorId : CommandNotFoundException
      + PSComputerName        : localhost

   无法将“python”项识别为 cmdlet、函数、脚本文件或可运行程序的名称。请检查名称的拼写，如果包括路径，请确保路径正确，然后
   再试一次。
      + CategoryInfo          : ObjectNotFound: (python:String) [], CommandNotFoundException
      + FullyQualifiedErrorId : CommandNotFoundException
      + PSComputerName        : localhost

   OK. No python in Env:Path any more. Just ignore error messages above this line.
   All found python have been configurated.
   Load configuration ...
   Merge found python and configurated python ...
   $PVM_REQUIRED_VER is
   Manipulated arguments:
   Selected version = 3
   Try use python in D:\Python383-64 to execute: python
   Python 3.8.3 (tags/v3.8.3:6f8c832, May 13 2020, 22:37:02) [MSC v.1924 64 bit (AMD64)] on win32
   Type "help", "copyright", "credits" or "license" for more information.
   >>>
   ```
   
6. All of your python versions found in Env::Path are configurated now. You can found the configuration file in 

   `C:\Users\<UserName>\pvm.json`

   ```{
   "timestamp":  "2020-06-23 14:25:35Z",
   "last_version":  "3",
   "versions":  
      {
         "3.8.3":  "D:\\Python383-64",
         "383":  "D:\\Python383-64",
         "3.7.6":  "D:\\Python37-64",
         "376":  "D:\\Python37-64",
         "3":  "D:\\Python383-64"
      }
   }

7. Feel free to edit this file to add/remove/rename python versions. Key of version can be any string. e.g. "old", "conda", etc.

   ```{
   "timestamp":  "2020-06-23 14:25:35Z",
   "last_version":  "3",
   "versions":  
      {
         "2.7.18":  "D:\\Python2718",
         "3.7.4":  "D:\\Python37-32",
         "374":  "D:\\Python37-32",
         "old":  "D:\\Python37-32",
         "3.7.6":  "D:\\Python37-64",
         "3.7":  "D:\\Python37-64",
         "376":  "D:\\Python37-64",
         "37":  "D:\\Python37-64",
         "3.8.3":  "D:\\Python383-64",
         "3.8":  "D:\\Python383-64",
         "383":  "D:\\Python383-64",
         "38":  "D:\\Python383-64",
         "3":  "D:\\Python383-64"
      }
   }
   ```


8. From now on, you can specify version to the python commands like (**-<version_number>** or **:<version_name>**):

    `python -3.8.3 example.py`

    `python -2.7.18 example.py`

    `python :374 example.py`

    `python :old example.py`

   And you can use it without version hint so that it will use the last (or the default) vesion automatically.
   


## TODO:

1. Scan virtual environments. (Env:WORKON_HOME)

2. The version_name can be virtualenv name.

