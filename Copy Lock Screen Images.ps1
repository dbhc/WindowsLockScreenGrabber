## Set Your Username Here ##########
$username = 'dchong'
####################################

$sourceFolder = 'C:\Users\'+$username+'\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*'
$destinationFolder = 'C:\Users\'+$username+'\Pictures\Lock Screen Images'
$destinationStagingFolder = 'C:\Users\'+$username+'\Pictures\Lock Screen Images\Temp Staging'

'copying from:'
$sourceFolder
'to:'
$destinationFolder


Add-Type -AssemblyName System.Drawing

if (!(Test-Path $destinationStagingFolder -pathType container)) {
	New-Item -ItemType Directory -Force -Path $destinationStagingFolder
}


Copy-Item -Path $sourceFolder -Destination $destinationStagingFolder

$Shell = New-Object -ComObject Shell.Application

Get-ChildItem -Path $destinationStagingFolder |
ForEach-Object {
	$name = $_.Name + ".jpg"
	$fullname = $destinationStagingFolder+$name

	Rename-Item -Path $_.FullName -NewName ($name)
}

Get-ChildItem -Path $destinationStagingFolder -Filter *.jpg | % {
    try
	{
    	$image = [System.Drawing.Image]::FromFile($_.FullName)
	    if ($image.width -eq 1920) {
	    	Copy-Item -Path $_.FullName -Destination $destinationFolder
	    }
	}
	catch
	{
	}
	finally
	{
		$image.Dispose()
	}

}

Remove-Item $destinationStagingFolder'\*'