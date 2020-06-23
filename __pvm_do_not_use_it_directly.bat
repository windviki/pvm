@echo off

rem PVM: Python version manager
rem by viki
rem windviki@gmail.com
rem
rem See readme.md!
rem

setlocal enabledelayedexpansion

set targetScirpt=%1
echo targetScirpt is %targetScirpt%

rem The processed args
set normArgs=

rem Iteration on the arg list
for %%x in (%*) do (
    echo bat args: %%~x
   (
      rem If the argument contains space in it
      for /f "tokens=2" %%A in ("%%~x") do (
         rem Quote it with tripple quotes!
         set normArgs=!normArgs! """%%~x"""
      )
   ) || (
      rem If no space found in argument
      set normArgs=!normArgs! %%~x
   )
)

rem Remove the space at the beginning of normArgs
for /f "tokens=1,* delims= " %%a in ("!normArgs!") do set normArgs=%%b

echo Processed args: !normArgs!

rem Call powershell
powershell -command %targetScirpt% !normArgs!
