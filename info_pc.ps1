# Appeler Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Créer la fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "Informations sur le PC"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"

# Fonction pour ajouter des labels proprement
function Add-Label {
    param ($text, $x, $y)
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $text
    $label.Location = New-Object System.Drawing.Point($x, $y)
    $label.AutoSize = $true
    $form.Controls.Add($label)
}

# Récupérer les informations système
$domain = (Get-WmiObject Win32_ComputerSystem).Domain
if ($domain -eq $env:COMPUTERNAME -or $domain -eq "WORKGROUP") { $domain = "Ce PC n'est pas dans un domaine" }
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like "192.*" }).IPAddress

# Ajouter les infos à la fenêtre
Add-Label "Domaine : $domain" 20 60
Add-Label "Utilisateur : $env:USERNAME" 20 90
Add-Label "Ordinateur : $env:COMPUTERNAME" 20 120
Add-Label "Adresse IP : $ip" 20 150
Add-Label "Hotline : numéro de téléphone" 20 180

# Ajouter un lien cliquable pour le ticket
$linkTicket = New-Object System.Windows.Forms.LinkLabel #Fonction pour creer un lien clicable 
$linkTicket.Text = "Creation d'un ticket" #Texte affiché
$linkTicket.Location = New-Object System.Drawing.Point(20, 210) #Position 
$linkTicket.AutoSize = $true #Ajuste la taille automatiquement
$linkTicket.add_Click({ #Permet d'insérer le lien
    Start-Process "lien voulu"
})
$form.Controls.Add($linkTicket)


# Afficher la fenêtre à la fin
$form.ShowDialog()
