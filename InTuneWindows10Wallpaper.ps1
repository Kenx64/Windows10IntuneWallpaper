$URL = "https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png"
$path = "C:\Temp"
$kenx64 = $path + "\kenx64"
$Download = $kenx64 + "\Powershell.png"

if ((Test-Path $kenx64) -eq $false) { 
     New-Item -Path $path -Name "kenx64" -ItemType "directory"
     start-bitstransfer -source $URL -destination $Download
}

$users = Get-ChildItem -path "REGISTRY::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" | % {Get-ItemProperty $_.pspath } | where ProfileImagePath -like "C:\Users\*"

Foreach ($user in $users) {
	$path = "REGISTRY::HKEY_USERS\"+ $user.PSChildName + "\Control Panel\Desktop\"
	try {
		Get-ItemProperty -path $path -name wallpaper -ErrorAction Stop
		Set-ItemProperty -path $path -name wallpaper -value $Download
		Set-ItemProperty -path $path -name WallpaperStyle -value "0"
		rundll32.exe user32.dll, UpdatePerUserSystemParameters
	}
	catch {
		Write-Host "An error occurred:"
		Write-Host $_
	}
}