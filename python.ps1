## PVM: Python version manager
## by viki
## windviki@gmail.com
##
## See readme.md!
##

# The configuration file
$PVM_CONFIG_PATH = Join-Path -Path $env:USERPROFILE -ChildPath "pvm.json"

# Get my root directory
$PVM_SCRIPT_ROOT = ""
Try
{
    $PVM_SCRIPT_ROOT = Get-Variable -Name PSScriptRoot -ValueOnly -ErrorAction Stop
}
Catch
{
    $PVM_SCRIPT_ROOT = Split-Path $script:MyInvocation.MyCommand.Path
}

$private:version_regex = "^(\d+(\.\d+(\.\d+)?)?)$"
$private:PVM_FOUND_PYTHON=@{}

# $PVM_SCRIPT_ROOT = "I:\TN\Segmentation"

if ([string]::IsNullOrEmpty($PVM_SCRIPT_ROOT))
{
    $host.UI.WriteErrorLine("`$PVM_SCRIPT_ROOT is Null or Empty!")
    exit 1
}
else 
{
    Write-Host "The script root is $PVM_SCRIPT_ROOT"
}

Function Wait-Expression
{
    param ($expression)
    Start-Job -ScriptBlock ([scriptblock]::Create($expression)) | Wait-Job | Receive-Job 6>&1
}

# Store local environment
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
$private:local_env = $Env:Path

# Remove the alias name 'python' on win10
Write-Host "Remove the 'python' alias in user's Env:Path"
$local_env = (
    $local_env.Split(';') | Where-Object { $_ -inotcontains "%USERPROFILE%\AppData\Local\Microsoft\WindowsApps" }
) -join ';'
# Set local environment for python path
Set-Item -Path Env:Path -Value $local_env


if ($local_env.Split(';') -notcontains $PVM_SCRIPT_ROOT)
{
    Write-Host "This script is not in Env:Path. Initialize the configuration."
    Write-Host "Scan for existing python ..."
    # Loop until no python is found!
    while (1) 
    {
        if ($local_env.Length -ne $Env:Path.Length)
        {
            # Set local environment for python path
            Set-Item -Path Env:Path -Value $local_env
        }

        Write-Host "Try to execute 'python', please ignore the error messages below this line ..."
        # Check python path
        $python_exe_path = Wait-Expression("python -c 'from __future__ import print_function; import sys; print(sys.executable)'")
        if ($python_exe_path)
        {
            $python_exe_path = $python_exe_path.Trim() -replace "`n","" -replace "`r",""
        }
        if ($python_exe_path)
        {
            Write-Host "Found existing Python path: $python_exe_path"
        }

        # Check python version
        $python_version = Wait-Expression("python --version")
        if ($python_version)
        {
            $python_version = $python_version.Replace("Python", "").Trim() -replace "`n","" -replace "`r",""
        }
        if ($python_version)
        {
            Write-Host "Found existing Python version:  $python_version"
        }

        # Filter the env path
        if (-Not [string]::IsNullOrEmpty($python_exe_path) -And (Test-Path -Path $python_exe_path))
        {
            $python_root = Split-Path -Path $python_exe_path -Parent
            $python_path_list = $python_root, (Join-Path -Path $python_root -ChildPath "Scripts"), (Join-Path -Path $python_root -ChildPath "DLLs")
            Write-Host "Python root is $python_root"

            if (-Not [string]::IsNullOrEmpty($python_version))
            {
                # Record the found python version
                $PVM_FOUND_PYTHON.$python_version = $python_root
                if ($python_version -match $version_regex)
                {
                    $python_major_version = $python_version.Split('.')[0]
                    $python_str_version = $python_version.Replace(".", "")
                    $PVM_FOUND_PYTHON.$python_major_version = $python_root
                    $PVM_FOUND_PYTHON.$python_str_version = $python_root
                }
            }

            foreach($key in ("Machine", "User"))
            {
                # Get current path
                $current_path_env = [System.Environment]::GetEnvironmentVariable('PATH', $key)
                # Write-Host "`$current_path_env for $key" is $current_path_env ...
                # Write-Host ""

                # Remove python path
                $new_path_env = (
                        $current_path_env.Split(';') | Where-Object { $python_path_list -inotcontains $_ }
                    ) -join ';'

                $local_env = (
                    $local_env.Split(';') | Where-Object { $python_path_list -inotcontains $_ }
                ) -join ';'

                # Has change
                if ($new_path_env.Length -ne $current_path_env.Length)
                {
                    # Write-Host "Now the `$new_path_env for $key" is $new_path_env ...
                    # Write-Host ""
                    # Set new path env (permament)
                    [System.Environment]::SetEnvironmentVariable('PATH', $new_path_env, $key)
                }

                Write-Host "Remove this python from $key Env:Path"
            }
        }
        else 
        {
            Write-Host "OK. No python in Env:Path any more. Just ignore error messages above this line."
            Write-Host "All found python have been configurated."
            break
        }
    }

    # Get current path
    $current_path_env = [System.Environment]::GetEnvironmentVariable('PATH', 'USER')
    # Add my path env (permament)
    [System.Environment]::SetEnvironmentVariable('PATH', ($PVM_SCRIPT_ROOT + ";" + $current_path_env), 'USER')
}

Write-Host "Prepare for configuration ..."
# Remove my path from local env
$local_env = (
    $local_env.Split(';') | Where-Object { $PVM_SCRIPT_ROOT -ne $_ }
) -join ';'

# Write-Host "Now the `$local_env is $local_env"

# Initialize Configuration
$PVM_CONFIG = @{}
if (-Not ($PVM_CONFIG_PATH | Test-Path))
{
    $PVM_CONFIG | ConvertTo-Json | Set-Content $PVM_CONFIG_PATH
}

$PVM_DEFAULT_CONFIG = @{
    versions = @{};
    last_version = "";
    timestamp = Get-Date -format 'u';
}

# Read Configuration
$PVM_CONFIG = Get-Content $PVM_CONFIG_PATH | ConvertFrom-Json

foreach($p in $PVM_DEFAULT_CONFIG.Keys)
{
    if ($PVM_CONFIG.PSObject.Properties.Name -notcontains $p)
    {
        $PVM_CONFIG | Add-Member -Name $p -value $PVM_DEFAULT_CONFIG.$p -MemberType NoteProperty
    }
}

Write-Host "Merge found python and configurated python ..."

# Merge the configuration with found python versions 
foreach($v in $PVM_FOUND_PYTHON.keys)
{
    $p = $PVM_FOUND_PYTHON[$v]

    # Do no have this python in configuration
    if (-Not $PVM_CONFIG.versions.$v)
    {
        $PVM_CONFIG.versions.$v = $p
    }
    else
    {
        $host.UI.WriteErrorLine("Skip a found python version $v with path $p because it conflicts with your configuration!")
    }
}

$PVM_REQUIRED_VER = ""
# Check version args
# e.g. 
# python -2
# python -3.8
# python :conda
$processed_args = [System.Collections.ArrayList]@()
for($i=0; $i -lt $args.Count; $i++)
{
    Write-Host "Arguments $i : " $args[$i]
    # version number or string number
    if ($args[$i] -match "^\-(\d+(\.\d+(\.\d+)?)?)$" -Or $args[$i] -match "^:(.*)$")
    {
        $PVM_REQUIRED_VER = $matches[1]
    }
    else
    {
        if ($args[$i] -match "\s")
        {
            $null = $processed_args.Add('"{0}"' -f $args[$i])
        }
        else
        {
            $null = $processed_args.Add($args[$i])
        }
    }
}

Write-Host "`$PVM_REQUIRED_VER is $PVM_REQUIRED_VER"
Write-Host "Left arguments: $processed_args"

$PVM_PYTHON_VER = $PVM_REQUIRED_VER

# Not require a specific version
if ([string]::IsNullOrEmpty($PVM_REQUIRED_VER))
{
    # Get the last version
    if ($PVM_CONFIG.last_version)
    {
        $PVM_PYTHON_VER = $PVM_CONFIG.last_version
    }
    else 
    {
        # Use the default version
        $PVM_PYTHON_VER = '3'

        # Do not have default version
        if (-Not $PVM_CONFIG.versions.$PVM_PYTHON_VER -And 
        -Not $PVM_FOUND_PYTHON.ContainsKey($PVM_PYTHON_VER))
        {
            if ($PVM_FOUND_PYTHON.Count -eq 0 -And $PVM_CONFIG.versions.PSobject.Properties.Name.Count -eq 0)
            {
                $host.UI.WriteErrorLine("`Cannot find any python! Please update your configurations at $PVM_CONFIG_PATH")
                exit 1
            }
            elseif ($PVM_FOUND_PYTHON.Count -ne 0)
            {
                # Use the first found version as default
                $PVM_PYTHON_VER = $PVM_FOUND_PYTHON.keys[0]
            }
            elseif ($PVM_CONFIG.versions.PSobject.Properties.Name.Count -ne 0)
            {
                # Use the first configurated version as default
                $PVM_PYTHON_VER = $PVM_CONFIG.versions.PSobject.Properties.Name[0]
            }
            else
            {
            }
        }
    }
}

# Validate required version
if (-Not $PVM_CONFIG.versions.$PVM_PYTHON_VER)
{
    $host.UI.WriteErrorLine("Cannot find version '$PVM_PYTHON_VER' in configuration!")
    exit 1
}
if ([string]::IsNullOrEmpty($PVM_CONFIG.versions.$PVM_PYTHON_VER))
{
    $host.UI.WriteErrorLine("Found empty python path for version '$PVM_PYTHON_VER' in configuration!")
    exit 1
}
if (-Not $PVM_CONFIG.versions.$PVM_PYTHON_VER | Test-Path)
{
    $host.UI.WriteErrorLine("Found invalid python path '$PVM_CONFIG.versions.$PVM_PYTHON_VER' for version '$PVM_PYTHON_VER' in configuration!")
    exit 1
}

# Update the last version 
$PVM_CONFIG.last_version = $PVM_PYTHON_VER
$PVM_CONFIG.timestamp = Get-Date -format 'u'

# Write Configuration
$PVM_CONFIG | ConvertTo-Json | Set-Content $PVM_CONFIG_PATH

Write-Host "Now use `$PVM_PYTHON_VER = " $PVM_PYTHON_VER ...

# Get the right python root path
$PVM_PYTHON_ROOT = $PVM_CONFIG.versions.$PVM_PYTHON_VER
$PVM_PYTHON_PATH_LIST = $PVM_PYTHON_ROOT, (Join-Path -Path $PVM_PYTHON_ROOT -ChildPath "Scripts"), (Join-Path -Path $PVM_PYTHON_ROOT -ChildPath "DLLs")

# Set local environment for python path
Set-Item -Path Env:Path -Value (($PVM_PYTHON_PATH_LIST + $local_env.Split(';')) -join ';')

# Start python
$PVM_ALL_ARGS = $PsBoundParameters.Values + $processed_args
$private:start_python_command = "python $PVM_ALL_ARGS"
Write-Host "Try: $start_python_command"

Invoke-Expression $start_python_command

# Add my path to local env
# Set local environment for python path
Set-Item -Path Env:Path -Value ($PVM_SCRIPT_ROOT + ';' + $local_env)
