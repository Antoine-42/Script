Write-Host "========================================"
Write-Host "Informations sur votre PC" -ForegroundColor Cyan
Write-Host "========================================"
Write-Host "Nom du domaine: Domain"
Write-Host "Nom de l'utilisateur : $($env:USERNAME)"
Write-Host "Nom de l'ordinateur : $($env:COMPUTERNAME)"
Write-Host "Adresse IP:"(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like "192.*" }).IPAddress
Write-Host "========================================"
Write-Host "Pour toute assistance :"
Write-Host "Hotline : 04 82 74 02 05" -ForegroundColor Green
Write-Host "Creer un ticket : https://monticket.link" -ForegroundColor Blue
Write-Host "========================================"
Pause