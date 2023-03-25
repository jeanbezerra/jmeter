# Author: Jean Carlos Bezerra Macena da Silva
# Version: 1.0.0-RELEASE
# Objective: Prepare env to dist test with JMeter 5.4.1 and Java 11 LTS (AdoptOpenJDK)
# Date: 14/09/2021
# How to use:
# Open PowerShell
# Get-ExecutionPolicy
# Get-ExecutionPolicy -List
# Set-ExecutionPolicy RemoteSigned
# Exec: wget https://raw.githubusercontent.com/jeancbezerra/jmeter/master/install_jmeter_dist_ws2019_aws.ps1 -OutFile install_jmeter_dist_ws2019_aws.ps1
# Exec: ./install_jmeter_dist_ws2019_aws.ps1

############################# Estrutura de pastas padronizadas

New-Item -Path C:\YAMAN\ -ItemType directory -Force
New-Item -Path C:\YAMAN\BOTS\ -ItemType directory -Force
New-Item -Path C:\YAMAN\OUTPUTS\ -ItemType directory -Force
New-Item -Path C:\YAMAN\MASSAS\ -ItemType directory -Force
New-Item -Path C:\YAMAN\FERRAMENTAS\ -ItemType directory -Force

############################# Download das ferramentas padronizadas

cd C:\YAMAN\FERRAMENTAS\

$ProgressPreference = 'SilentlyContinue'
#wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/MicrosoftEdgeEnterpriseX64.msi -OutFile MicrosoftEdgeEnterpriseX64.msi
#wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/apache-jmeter-5.4.1.zip -OutFile apache-jmeter-5.4.1.zip
wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/apache-jmeter/apache-jmeter-5.4.1.zip -OutFile apache-jmeter-5.4.1.zip
wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/java/microsoft/microsoft-jdk-11.0.16.1-windows-x64.msi -OutFile microsoft-jdk-11.0.16.1-windows-x64.msi

############################# Instalacao Passiva (MSI compatible)

Expand-Archive -Path C:\YAMAN\FERRAMENTAS\apache-jmeter-5.4.1.zip -DestinationPath C:\YAMAN\FERRAMENTAS\
#Expand-Archive -Path C:\YAMAN\FERRAMENTAS\apache-jmeter-5.4.1.zip -DestinationPath C:\YAMAN\FERRAMENTAS\
#Start-Process C:\YAMAN\FERRAMENTAS\OpenJDK11U-jdk_x64_windows_hotspot_11.0.12_7.msi -ArgumentList "/quiet /passive"
Start-Process C:\YAMAN\FERRAMENTAS\microsoft-jdk-11.0.16.1-windows-x64.msi -ArgumentList "/quiet /passive"
#Start-Process C:\YAMAN\FERRAMENTAS\MicrosoftEdgeEnterpriseX64.msi -ArgumentList "/quiet /passive"

############################# Variavel de ambiente

$Env:JAVA_HOME='C:\Program Files\Microsoft\jdk-11.0.16.101-hotspot'
$Env:JMETER_HOME='C:\YAMAN\FERRAMENTAS\apache-jmeter-5.4.1'

[Environment]::SetEnvironmentVariable("JAVA_HOME","C:\Program Files\Microsoft\jdk-11.0.16.101-hotspot","Machine")
[Environment]::SetEnvironmentVariable("JMETER_HOME","C:\YAMAN\FERRAMENTAS\apache-jmeter-5.4.1","Machine")

$path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$newpath = $path + ";" + $Env:JAVA_HOME + "\bin" + ";" + $Env:JMETER_HOME + "\bin"
[Environment]::SetEnvironmentVariable("Path", $newpath, 'Machine')

############################# Liberacao de portas

Set-NetFirewallProfile -All -Enabled True
New-NetFirewallRule -DisplayName 'JMETER-PORT-INBOUND' -Profile @('Domain','Private','Public') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('4000')

############################# Desabilitar Firewall do Windows

Get-NetFirewallProfile | Format-Table Name, Enabled
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
Get-NetFirewallProfile | Format-Table Name, Enabled

############################# Windows TCP Tuning

netsh int tcp set global autotuninglevel=normal
netsh int tcp show global

Get-NetTCPSetting | Set-NetTCPSetting -AutoTuningLevelLocal Normal
Get-NetTCPSetting | Format-List SettingName,Autotuninglevel*

netsh int ipv4 set dynamicport tcp start=1025 num=64000

Get-Item -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' | New-Item -Name 'TcpTimedWaitDelay' -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'TcpTimedWaitDelay' -Value "0x1E" -PropertyType DWORD -Force

Get-Item -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' | New-Item -Name 'StrictTimeWaitSeqCheck' -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'StrictTimeWaitSeqCheck' -Value "1" -PropertyType DWORD -Force

cd C:\Users\admin\Desktop
