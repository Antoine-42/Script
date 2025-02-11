
# Charger Windows Forms
Add-Type -AssemblyName System.Windows.Forms  # Charge les composants nécessaires pour créer une interface graphique

# Créer la fenêtre
$form = New-Object System.Windows.Forms.Form  # Création de la fenêtre principale
$form.Text = "Nom de la fenêtre"  # Titre affiché dans la barre de la fenêtre
$form.Size = New-Object System.Drawing.Size(400, 350)  # Définition de la taille de la fenêtre
$form.StartPosition = "CenterScreen"  # Centrer la fenêtre sur l'écran
$form.BackColor = [System.Drawing.Color]::White  # Fond blanc

# Ajouter un logo en haut à droite
$logo = New-Object System.Windows.Forms.PictureBox  # Création d'un objet PictureBox pour afficher une image
$logo.Image = [System.Drawing.Image]::FromFile("chemin du logo")  # Charger l'image du logo
$logo.SizeMode = "StretchImage"  # Adapter l'image pour remplir la boîte sans la déformer
$logo.Size = New-Object System.Drawing.Size(140, 40)  # Définition de la taille du logo
$logo.Location = New-Object System.Drawing.Point(235, 10)  # Positionnement du logo en haut à droite
$form.Controls.Add($logo)  # Ajout du logo à la fenêtre

# Ajouter un titre
$labelTitle = New-Object System.Windows.Forms.Label  # Création d'un label pour afficher du texte
$labelTitle.Text = "Informations sur votre PC"  # Texte du titre
$labelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)  # Police en gras et taille 12
$labelTitle.Location = New-Object System.Drawing.Point(20, 20)  # Position du titre 
$labelTitle.AutoSize = $true  # Ajuster automatiquement la taille en fonction du texte
$form.Controls.Add($labelTitle)  # Ajouter le titre à la fenêtre

# Récupérer les infos système
$domain = (Get-WmiObject Win32_ComputerSystem).Domain  # Récupération du nom du domaine
if ($domain -eq $env:COMPUTERNAME -or $domain -eq "WORKGROUP") { 
    $domain = "Ce PC n'est pas dans un domaine"  # Remplacement si l'ordinateur est hors domaine
}
while (-not ($ip = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress -match '^(?!169\.)')) { Start-Sleep 1 }; $ip # Récupération de l'adresse IP

# Ajouter les infos système sous forme de labels
$y = 60  # Position verticale initiale pour afficher les infos
@("Domaine : $domain", "Utilisateur : $env:USERNAME", "Ordinateur : $env:COMPUTERNAME", "Adresse IP : $ip", "Hotline : numéro de téléphone") | 
ForEach-Object {
    $label = New-Object System.Windows.Forms.Label  # Création d'un label pour chaque info
    $label.Text = $_  # Texte à afficher
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10)  # Police normale, taille 10
    $label.Location = New-Object System.Drawing.Point(20, $y)  # Positionnement des labels à gauche
    $label.AutoSize = $true  # Ajustement automatique de la taille du texte
    $form.Controls.Add($label)  # Ajout du label à la fenêtre
    $y += 25  # Décalage vertical pour la ligne suivante
}

# Ajouter un lien cliquable pour créer un ticket
$link = New-Object System.Windows.Forms.LinkLabel  # Création d'un label cliquable (lien)
$link.Text = "Création d'un ticket"  # Texte affiché pour le lien
$link.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)  # Police en gras
$link.Location = New-Object System.Drawing.Point(20, $y)  # Position du lien sous les infos
$link.AutoSize = $true  # Ajustement automatique de la taille
$link.LinkColor = [System.Drawing.Color]::Blue  # Définition de la couleur bleue du lien
$link.add_Click({ Start-Process "lien pour cree un ticket" })  # Ouvre le lien dans le navigateur par défaut
$form.Controls.Add($link)  # Ajouter le lien à la fenêtre

# Ajouter un bouton "Fermer"
$btnClose = New-Object System.Windows.Forms.Button  # Création d'un bouton interactif
$btnClose.Text = "Fermer"  # Texte affiché sur le bouton
$btnClose.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)  # Police
$btnClose.ForeColor = [System.Drawing.Color]::White  # Texte blanc
$btnClose.BackColor = [System.Drawing.Color]::Black  # Fond noir
$btnClose.Size = New-Object System.Drawing.Size(120, 40)  # Définition de la taille du bouton 
$btnClose.Location = New-Object System.Drawing.Point(130, 260)  # Position centré horizontalement
$btnClose.Add_Click({ $form.Close() })  # Ferme la fenêtre lorsqu'on clique dessus
$form.Controls.Add($btnClose)  # Ajout du bouton à la fenêtre

Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File 'chemin du programme'" -NoNewWindow -PassThru | Out-Null

# Afficher la fenêtre
$form.ShowDialog()  # Afficher la fenêtre et bloquer l'exécution tant qu'elle est ouverte
