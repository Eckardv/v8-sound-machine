# Generates three package CARD images (tier name + price baked in) via RunComfy GPT Image 2.
# Same auth as generate-gbp-photos.ps1: $env:RUNCOMFY_TOKEN or %USERPROFILE%\.runcomfy-token

$ErrorActionPreference = "Stop"
$token = $env:RUNCOMFY_TOKEN
$tokenFile = Join-Path $env:USERPROFILE ".runcomfy-token"
if (-not $token -and (Test-Path $tokenFile)) { $token = (Get-Content $tokenFile -Raw).Trim() }
if (-not $token) { Write-Error "No token. Set RUNCOMFY_TOKEN or create $tokenFile."; exit 1 }

$base = "https://model-api.runcomfy.net/v1"
$model = "openai/gpt-image-2/text-to-image"
$headers = @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" }
$outDir = Join-Path $PSScriptRoot "..\assets\gbp"
New-Item -ItemType Directory -Force $outDir | Out-Null

$style = "Premium cinematic product photography on a dark stage, deep black background, magenta stage spotlight from above, violet-purple footlight glow from below, faint cool blue rim light, atmospheric haze in the beams, fine film grain, polished chrome and matte-black equipment. No people, no brand logos, no text other than the exact headline specified."

$jobs = @(
    @{ name = "bronze-card"; prompt = "$style The scene: a single professional PA loudspeaker on a tripod stand with two wireless microphones in a chrome stand beside it, on a reflective stage floor - an intimate ceremony sound setup. In the upper left, a bold condensed uppercase headline in brushed-chrome metallic lettering reads exactly `"BRONZE`", and directly below it a smaller clean white sans-serif line reads exactly `"FROM R1,950`". Keep all other space free of text." },
    @{ name = "silver-card"; prompt = "$style The scene: a professional DJ controller with glowing pads on a matte-black booth, two PA loudspeakers on stands, one wireless microphone, and a compact dance-floor light casting a few magenta and purple beams - a mid-size party setup. In the upper left, a bold condensed uppercase headline in brushed-chrome metallic lettering reads exactly `"SILVER`", and directly below it a smaller clean white sans-serif line reads exactly `"FROM R3,950`". Keep all other space free of text." },
    @{ name = "gold-card"; prompt = "$style The scene: a full premium wedding production - twin loudspeaker towers with subwoofers on truss stands, a sleek DJ booth at center, wireless microphones on stands, and a lighting truss overhead projecting layered magenta, purple and blue beams through haze - grand ceremony-and-reception scale. In the upper left, a bold condensed uppercase headline in brushed-chrome metallic lettering reads exactly `"GOLD`", and directly below it a smaller clean white sans-serif line reads exactly `"FROM R6,500`". Keep all other space free of text." }
)

foreach ($j in $jobs) {
    Write-Host "Submitting $($j.name)..."
    $body = @{ prompt = $j.prompt; size = "1536_1024" } | ConvertTo-Json
    $req = Invoke-RestMethod -Method Post -Uri "$base/models/$model" -Headers $headers -Body $body
    $id = $req.request_id
    if (-not $id) { Write-Error "No request_id: $($req | ConvertTo-Json -Depth 5)"; exit 1 }

    do {
        Start-Sleep -Seconds 6
        $status = (Invoke-RestMethod -Method Get -Uri "$base/requests/$id/status" -Headers $headers).status
        Write-Host "  $($j.name): $status"
    } while ($status -in @("in_queue", "in_progress"))

    if ($status -ne "completed") { Write-Error "$($j.name) failed: '$status'"; exit 1 }

    $result = Invoke-RestMethod -Method Get -Uri "$base/requests/$id/result" -Headers $headers
    $url = ([regex]::Matches(($result | ConvertTo-Json -Depth 10), 'https://[^"\\]+\.(png|jpe?g|webp)') | Select-Object -First 1).Value
    if (-not $url) { Write-Error "No image URL in result"; exit 1 }

    Invoke-WebRequest -Uri $url -OutFile (Join-Path $outDir "$($j.name).png")
    Write-Host "  Saved -> assets/gbp/$($j.name).png"
}
Write-Host "`nDone."
