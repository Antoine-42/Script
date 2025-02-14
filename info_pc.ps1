# Charger Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Créer la fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "Text en haut de la page"
$form.AutoSize = $true
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::White

# Ajouter un logo en haut à droite avec gestion d'erreur
$logo = New-Object System.Windows.Forms.PictureBox
$logo.SizeMode = "StretchImage"
$logo.Size = New-Object System.Drawing.Size(180, 45)
$logo.Location = New-Object System.Drawing.Point(280, 15)
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $webClient = New-Object System.Net.WebClient
    $stream = $webClient.OpenRead("lien du logo voulu")
    $logo.Image = [System.Drawing.Image]::FromStream($stream)
    $stream.Close()
} catch {
    Write-Host "Erreur lors du chargement du logo : $_"
    # Optionnel : assigner une image locale ou laisser vide
}
$form.Controls.Add($logo)

# Ajouter un titre
$labelTitle = New-Object System.Windows.Forms.Label
$labelTitle.Text = "Informations sur votre PC"
$labelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$labelTitle.Location = New-Object System.Drawing.Point(20, 20)
$labelTitle.AutoSize = $true
$form.Controls.Add($labelTitle)

# Récupérer les infos système
$computerSystem = Get-WmiObject Win32_ComputerSystem
$domain = $computerSystem.Domain
if ($domain -eq $env:COMPUTERNAME -or $domain -eq "WORKGROUP") {
    $domain = "Ce PC n'est pas dans un domaine"
}

# Récupération optimisée de l'adresse IP (excluant les adresses APIPA)
$ipAddresses = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike "169.254.*" }
if ($ipAddresses) {
    $ip = $ipAddresses[0].IPAddress
} else {
    $ip = "Adresse IP non trouvée"
}

# Afficher les informations système sous forme de labels
$infoList = @(
    "Domaine : $domain",
    "Utilisateur : $env:USERNAME",
    "Ordinateur : $env:COMPUTERNAME",
    "Adresse IP : $ip",
    "Hotline : Numéro de téléphone"
)
$y = 60
foreach ($info in $infoList) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $info
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $label.Location = New-Object System.Drawing.Point(20, $y)
    $label.AutoSize = $true
    $form.Controls.Add($label)
    $y += 25
}

# Ajouter un lien cliquable pour créer un ticket
$linkTicket = New-Object System.Windows.Forms.LinkLabel
$linkTicket.Text = "Création d'un ticket"
$linkTicket.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$linkTicket.Location = New-Object System.Drawing.Point(20, $y)
$linkTicket.AutoSize = $true
$linkTicket.LinkColor = [System.Drawing.Color]::Blue
$linkTicket.add_Click({ Start-Process "lien création d'un ticket" })
$form.Controls.Add($linkTicket)
$y += 30

# Ajouter un lien cliquable pour télécharger Teamviewer
$linkTeamviewer = New-Object System.Windows.Forms.LinkLabel
$linkTeamviewer.Text = "Télécharger Teamviewer"
$linkTeamviewer.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$linkTeamviewer.Location = New-Object System.Drawing.Point(20, $y)
$linkTeamviewer.AutoSize = $true
$linkTeamviewer.LinkColor = [System.Drawing.Color]::Blue
$linkTeamviewer.add_Click({ Start-Process "lien pour télécharger TeamViewer" })
$form.Controls.Add($linkTeamviewer)
$y += 30

# Ajouter un bouton "Fermer"
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Fermer"
$btnClose.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnClose.ForeColor = [System.Drawing.Color]::White
$btnClose.BackColor = [System.Drawing.Color]::Black
$btnClose.Size = New-Object System.Drawing.Size(200, 40)
# Centrer le bouton horizontalement par rapport à la fenêtre
$btnClose.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $btnClose.Width) / 2), $y)
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# Lancer le script info.ps1 en arrière-plan si celui-ci existe
$scriptPath = "E:\script\info.ps1"
if (Test-Path $scriptPath) {
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`"" -NoNewWindow -PassThru | Out-Null
} else {
    Write-Host "Script $scriptPath non trouvé."
}

# Afficher la fenêtre
$form.ShowDialog()
