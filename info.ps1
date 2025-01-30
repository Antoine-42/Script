Write-Host "========================================"
Write-Host "Informations sur votre PC" -ForegroundColor Cyan
Write-Host "========================================"
Write-Host "Nom du domaine: Domain"
Write-Host "Nom de l'utilisateur : $($env:USERNAME)"
Write-Host "Nom de l'ordinateur : $($env:COMPUTERNAME)"
Write-Host "Adresse IP:"(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like "192.*" }).IPAddress
Write-Host "========================================"
Write-Host "Pour toute assistance :"
Write-Host "Hotline : numéro de la hotline" -ForegroundColor Green
Write-Host "Creer un ticket : lien pour creer un ticket" -ForegroundColor Blue
Write-Host "========================================"
Pause
