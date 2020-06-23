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
   
5. Double-click on this python.ps1 to run the automatic configuration initialization. If you get a python REPL, it's done.
   
6. All of your python versions found in Env::Path are configurated now. You can found the configuration file in 

   `C:\Users\<UserName>\pvm.json`

   ```{
   "timestamp":  "2020-06-23 10:44:05Z",
   "last_version":  "3",
   "versions":  
      {
         "3.7.6":  "D:\\Python37-64",
         "376":  "D:\\Python37-64",
         "37":  "D:\\Python37-64",
         "3.8.3":  "D:\\Python383-64",
         "3.8":  "D:\\Python383-64",
         "383":  "D:\\Python383-64",
         "3":  "D:\\Python383-64"
      }
   }

7. Feel free to edit this file to add/remove/rename python versions. Key of version can be any string. e.g. "old", "conda", etc.

   ```{
   "timestamp":  "2020-06-23 10:44:05Z",
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

