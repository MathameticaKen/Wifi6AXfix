<#	
	.NOTES
	===========================================================================
	 Created on:   	4/7/2022 1:50 PM
	 Created by:   	MathematicaKen
	 Filename:     	Update-WiFi.ps1
	===========================================================================
	.DESCRIPTION
		Upgrade Intel WiFi driver with DevCon
#>
Function Write-Log
{
	[cmdletbinding()]
	Param (
		[Parameter(Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$Message,
		[Parameter(Position = 1)]
		[string]$LogPath = "$env:windir\logs\software\Update-WiFi.log"
	)
	
	#Pass on the message to Write-Verbose if -Verbose was detected
	Write-Verbose $Message
	
	#only write to the log file if the $LoggingPreference variable is set to Continue
	
	
	#if a $loggingFilePreference variable is found in the scope
	#hierarchy then use that value for the file, otherwise use the default
	#$LogPath
	if ($loggingFilePreference)
	{
		$LogFile = $loggingFilePreference
	}
	else
	{
		$LogFile = $LogPath
	}
	
	Write-Output "$(Get-Date) - $Message" | Out-File -FilePath $LogFile -Append
	
	
} #end function

Write-Log "Script starting to run"
write-log "................................................................................................................"
Get-Childitem c:\Windows\System32\drivers\netw*.sys | ForEach-Object {
	
	Write-Log "Driver File: $($_.name)"
	Write-Log "Driver Version: $($(Get-ItemProperty $_).VersionInfo.Fileversion)"
}
$wifi = get-netadapter -Name Wi-Fi | select -ExpandProperty PnPDeviceID | select -First 1
$wifi_sub = $wifi.substring(22, 15)
$wifi = $wifi.substring(0, 37)

Get-Childitem *.inf | select -ExpandProperty fullname | ForEach-Object {
	if ($(get-content $_) -match $wifi_sub)
	{
		write-log "driver matched $wifi, start to upgrade...."
		.\devcon update $_  $wifi
	}
	
}
write-log "driver matched $wifi, upgrade completed"

write-log "................................................................................................................"

Get-Childitem c:\Windows\System32\drivers\netw*.sys | % {
	
	Write-Log "Driver File: $($_.name)"
	Write-Log "Driver Version: $($(Get-ItemProperty $_).VersionInfo.Fileversion)"
}