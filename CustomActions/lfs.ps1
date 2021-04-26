# Post to Slack Lock Notification for Sourcetree
# Written by @KrakenFuego for @BrueCI & @SilverRainGames
# MIT License

$slackWebhookURI = "<<INSERT SLACK WEBHOOK URI HERE>>"

# Configure Args
$process=$args[1]
$repo=$args[2]
$filePath=$args[3]
$userDescription=$args[4]

# Function Library
# Start Process function
function fStartProcess([string]$sProcess,[string]$sArgs,[ref]$pOutPut)
{
    $oProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
    $oProcessInfo.FileName = $sProcess
    $oProcessInfo.RedirectStandardError = $true
    $oProcessInfo.RedirectStandardOutput = $true
    $oProcessInfo.UseShellExecute = $false
    $oProcessInfo.Arguments = $sArgs
    $oProcess = New-Object System.Diagnostics.Process
    $oProcess.StartInfo = $oProcessInfo
    $oProcess.Start() | Out-Null
    $oProcess.WaitForExit() | Out-Null
    $sSTDERR = $oProcess.StandardError.ReadToEnd()
    $pOutPut.Value=$sSTDERR
    return $oProcess.ExitCode
}


# Run the Git Stuff
Set-Location ($repo)
Write-Output "Performing Git Actions"
$gitOutput=""
$gitRet=fStartProcess git lfs" $process $filepath"  ([ref]$gitOutput)

# Check if Sourcetree has silently errored
if ($gitRet -eq 2) {
    Write-Output $gitOutput
    exit 1
    }
else {
    Write-Output "Success"
}

# Slack Data
$webhookUrl = $slackWebhookURI
$filepath = ($filePath)
$user = "$($env:ComputerName)\$($env:Username) - $userDescription"

if ($process -eq 'lock') {
    Write-Output "Posting Lock to Slack"

    # Build JSON Schema
	$body = ConvertTo-Json @{
		pretext = "Lock Notification"
		text = "File Path: $filePath `n Status: Locked `n User: $user"
		color = "#FF0000"
    }
    
}
elseif ($process -eq 'unlock') {
    Write-Output "Posting UnLock to Slack"

    # Build JSON Schema
	$body = ConvertTo-Json @{
		pretext = "Unlock Notification"
		text = "File Path: $filePath `n Status: Unlocked `n User: $user"
		color = "#00FF00"
    }

}
else {
    Write-Output "Unrecognised command - Not Posting to Slack"
}

try {
    Invoke-RestMethod -uri $webhookUrl -Method Post -body $body -ContentType 'application/json' | Out-Null
} catch {
    Write-Output (Get-Date) ": Update to Slack went wrong..."
}
