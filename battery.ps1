# Path to the WAV file
$audioFile = "C:\alarms\alarm.wav"
# Path to the stop flag file
$stopFile = "C:\alarms\stop_alarm.txt"

# Function to play audio with the ability to stop
function Play-Audio {
    $player = New-Object System.Media.SoundPlayer
    $player.SoundLocation = $audioFile

    # Start playing the audio
    $player.Play()

    # Check for the stop file while the audio is playing
    for ($i = 0; $i -lt 30; $i++) {
        if (Test-Path $stopFile) {
            Write-Host "Stop file detected. Stopping alarm..."
            Remove-Item $stopFile
            $player.Stop() # Attempt to stop playback
            break
        }
        Start-Sleep -Seconds 1
    }
}

# Function to play alarm based on battery status
function Play-Alarm {

    # Get battery information
    $battery = Get-WmiObject Win32_Battery
    Write-Host $battery.EstimatedChargeRemaining

    # Check battery conditions
    if (($battery.EstimatedChargeRemaining -ge 79 -and $battery.BatteryStatus -eq 2) -or 
        ($battery.EstimatedChargeRemaining -le 21 -and $battery.BatteryStatus -ne 2)) {
        Play-Audio
    }
}


# Main loop
while ($true) {
    Play-Alarm
    Start-Sleep -Seconds 60
}








