## PVM: Python version manager
## by viki
## windviki@gmail.com
##
## See readme.md!
##
$PVM_SCRIPT_ROOT = ""
Try
{
    $PVM_SCRIPT_ROOT = Get-Variable -Name PSScriptRoot -ValueOnly -ErrorAction Stop
}
Catch
{
    $PVM_SCRIPT_ROOT = Split-Path $script:MyInvocation.MyCommand.Path
}

$scriptPath = Join-Path $PVM_SCRIPT_ROOT "__pvm_do_not_use_it_directly.ps1"
$argumentList = $PsBoundParameters.Values + $args
$processedArgs = [System.Collections.ArrayList]@()
for($i=0; $i -lt $argumentList.Count; $i++)
{
    # Write-Host "Arguments $i : " $argumentList[$i]
    if ($argumentList[$i] -match "\s")
    {
        $null = $processedArgs.Add('"{0}"' -f $argumentList[$i])
    }
    else
    {
        $null = $processedArgs.Add($argumentList[$i])
    }
}
# Write-Host "Input argumentList: $processedArgs"
$env:PVM_TARGET_APP = 'workon'; Invoke-Expression "& `"$scriptPath`" $processedArgs"
