## Unistall Process

Remove-Item -Path C:\YAMAN_IAC\ -Recurse

#Get-WmiObject -Class Win32_Product | Select-Object -Property Name
$UNINSTALL_PROGRAM_AWSCLI = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "AWS Command Line Interface v2"}
$UNINSTALL_PROGRAM_AWSCLI.uninstall()

$UNINSTALL_PROGRAM_AZURECLI = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Microsoft Azure CLI"}
$UNINSTALL_PROGRAM_AZURECLI.uninstall()

## Install Process

New-Item -Path C:\YAMAN_IAC\ -ItemType directory -Force
New-Item -Path C:\YAMAN_IAC\TERRAFORM -ItemType directory -Force

cd C:\YAMAN_IAC\

$ProgressPreference = 'SilentlyContinue'

wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/iac/aws-cli-2.msi -OutFile aws-cli-2.msi
wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/iac/azure-cli-2.msi -OutFile azure-cli-2.msi
Start-Process C:\YAMAN_IAC\aws-cli-2.msi  -Wait -ArgumentList "/quiet /passive /norestart"
Start-Process C:\YAMAN_IAC\azure-cli-2.msi -Wait -ArgumentList "/quiet /passive /norestart"

cd C:\YAMAN_IAC\TERRAFORM\
wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/iac/terraform.zip -OutFile terraform.zip
Expand-Archive -Path C:\YAMAN_IAC\TERRAFORM\terraform.zip -DestinationPath C:\YAMAN_IAC\TERRAFORM\

$Env:TERRAFORM_HOME='C:\YAMAN_IAC\TERRAFORM\'
[Environment]::SetEnvironmentVariable("TERRAFORM_HOME","C:\YAMAN_IAC\TERRAFORM\","Machine")
$path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$newpath = $path + ";" + "%TERRAFORM_HOME%"
[Environment]::SetEnvironmentVariable("Path", $newpath, 'Machine')
