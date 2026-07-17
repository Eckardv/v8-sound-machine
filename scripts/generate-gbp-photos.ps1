# Generates the three GBP package photos via the RunComfy Model API (FLUX 2 Klein 9B).
# Token: set $env:RUNCOMFY_TOKEN, or save it as the only line of %USERPROFILE%\.runcomfy-token
# (get it from runcomfy.com/profile). Never commit the token.

$ErrorActionPreference = "Stop"
$token = $env:RUNCOMFY_TOKEN
$tokenFile = Join-Path $env:USERPROFILE ".runcomfy-token"
if (-not $token -and (Test-Path $tokenFile)) { $token = (Get-Content $tokenFile -Raw).Trim() }
if (-not $token) { Write-Error "No token. Set RUNCOMFY_TOKEN or create $tokenFile (from runcomfy.com/profile)."; exit 1 }

$base = "https://model-api.runcomfy.net/v1"
$model = "blackforestlabs/flux-2-klein/9b/text-to-image"
$headers = @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" }
$outDir = Join-Path $PSScriptRoot "..\assets\gbp"
New-Item -ItemType Directory -Force $outDir | Out-Null

# Shared brand style (from brand-kit.md): lit stage, magenta key / purple footlight / blue rim, haze, grain.
$style = "on a dark stage with a deep black background, a magenta stage spotlight from high above, a soft violet-purple footlight glow rising from below, and a faint cool blue rim light tracing the edges. Subtle atmospheric haze in the light beams, fine film grain, gentle vignette, polished chrome and matte-black equipment finishes. Premium cinematic product photography, photoreal, shallow depth of field. No people, no text, no lettering, no logos."

$jobs = @(
    @{ name = "bronze-package"; prompt = "A single professional PA loudspeaker on a tripod stand beside two wireless microphones resting upright in a small chrome stand, arranged neatly on a dark reflective stage floor — a minimal, intimate ceremony sound setup, modest and precise, $style" },
    @{ name = "silver-package"; prompt = "A professional DJ controller with glowing pads on a matte-black booth table, flanked by two PA loudspeakers on stands, with a compact dance-floor lighting fixture projecting thin magenta and purple beams overhead — a mid-size party setup, energetic but tidy, $style" },
    @{ name = "gold-package"; prompt = "A full premium event production rig: twin loudspeaker towers with subwoofers, a sleek DJ booth at center, and an array of stage lighting fixtures projecting layered magenta, purple and blue beams through haze — grand wedding-reception scale, monumental and luxurious, $style" }
)

foreach ($j in $jobs) {
    Write-Host "Submitting $($j.name)..."
    $body = @{ prompt = $j.prompt; steps = 25; width = 1440; height = 1080 } | ConvertTo-Json
    $req = Invoke-RestMethod -Method Post -Uri "$base/models/$model" -Headers $headers -Body $body
    $id = $req.request_id
    if (-not $id) { Write-Error "No request_id returned: $($req | ConvertTo-Json -Depth 5)"; exit 1 }

    do {
        Start-Sleep -Seconds 5
        $status = (Invoke-RestMethod -Method Get -Uri "$base/requests/$id/status" -Headers $headers).status
        Write-Host "  $($j.name): $status"
    } while ($status -in @("in_queue", "in_progress"))

    if ($status -ne "completed") { Write-Error "$($j.name) failed with status '$status'"; exit 1 }

    $result = Invoke-RestMethod -Method Get -Uri "$base/requests/$id/result" -Headers $headers
    # ponytail: grab the first https URL anywhere in the result JSON — schema field name varies by model
    $url = ([regex]::Matches(($result | ConvertTo-Json -Depth 10), 'https://[^"\\]+\.(png|jpe?g|webp)') | Select-Object -First 1).Value
    if (-not $url) { Write-Error "No image URL in result: $($result | ConvertTo-Json -Depth 5)"; exit 1 }

    $dest = Join-Path $outDir "$($j.name).png"
    Invoke-WebRequest -Uri $url -OutFile $dest
    Write-Host "  Saved -> $dest"
}
Write-Host "`nDone. 3 photos in assets/gbp/ - review, then upload to the GBP services/photos section."
