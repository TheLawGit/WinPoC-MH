param(
[string]$msi,
[string]$mst,
[string]$DmrCA,
[string]$DmrCAServer
)
$errorActionPreference="Stop"
$drivePath="%SYSTEMDRIVE%"


if([System.Environment]::Is64BitOperatingSystem)
{ 
	$regkey = 'HKLM:SOFTWARE\Wow6432Node\AdventNet\DesktopCentral\DCAgent'
	Write-Output "64-bit architecture detected"
}
else
{
	$regkey = 'HKLM:SOFTWARE\AdventNet\DesktopCentral\DCAgent'
	Write-Output "32-bit architecture detected"
}

if(Test-Path $regkey)
{
	$agentVersion =(Get-ItemProperty $regkey).DCAgentVersion
}
		
if( -not $agentVersion)
{
#Write-Output $PSScriptRoot
[string]$msiFile = "$PSScriptRoot\$msi"
[string]$mstFile = "$PSScriptRoot\$mst"
[string]$DmrCAServer = "$PSScriptRoot\$DmrCAServer"
[string]$DmrCA = "$PSScriptRoot\$DmrCA"

[string]$InstallCmd = "msiexec.exe /i $msiFile  TRANSFORMS=$mstFile ENABLESILENT=yes REBOOT=ReallySuppress /qn MSIRESTARTMANAGERCONTROL=Disable INSTALLSOURCE=GPO SERVER_ROOT_CRT=$DmrCAServer DS_ROOT_CRT=$DmrCA /lv $DrivePath\dcagentInstaller.log"

Write-Output $InstallCmd

cmd /c $InstallCmd
}
