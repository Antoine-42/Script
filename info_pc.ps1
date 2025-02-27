# Cacher la fenêtre noire de PowerShell
Add-Type -Name WinAPI -Namespace Win32 -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern int ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
"@
$consolePtr = [Win32.WinAPI]::GetConsoleWindow()

# Définition des variables
$scriptQS = "Chemin dans C:"
$tvPath = "$scriptQS\TeamViewerQS.exe"
$downloadURL = "Llien de telechargement de TeamViewer"

# Vérifier si TeamViewer QuickSupport est présent
if (!(Test-Path $tvPath)) {
    Write-Host "TeamViewer QuickSupport non trouvé. Téléchargement  dans 5 secondes..."
    Start-Sleep -Seconds 5
}

# Charger Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Créer la fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "Texte das"
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
    $stream = $webClient.OpenRead("https://jl-systems.fr/wp-content/uploads/2020/09/Logo.jpg")
    $logo.Image = [System.Drawing.Image]::FromStream($stream)
    $stream.Close()
} catch {
    Write-Host "Erreur lors du chargement du logo : $_"
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

# Récupération de l'adresse IP optimisée
$ipAddresses = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike "169.254.*" }
$ip = if ($ipAddresses.Count -gt 0) { $ipAddresses[0].IPAddress } else { "Adresse IP non trouvée" }

# Afficher les informations système
$infoList = @("Domaine : $domain", "Utilisateur : $env:USERNAME", "Ordinateur : $env:COMPUTERNAME", "Adresse IP : $ip", "Hotline : 04 82 74 02 05")
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

# Ajouter un lien pour créer un ticket
$linkTicket = New-Object System.Windows.Forms.LinkLabel
$linkTicket.Text = "Création d'un ticket"
$linkTicket.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$linkTicket.Location = New-Object System.Drawing.Point(20, $y)
$linkTicket.AutoSize = $true
$linkTicket.LinkColor = [System.Drawing.Color]::Blue
$linkTicket.add_Click({ Start-Process "Lien pour cree un ticket" })
$form.Controls.Add($linkTicket)
$y += 30

# Ajouter un bouton "Fermer"
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Fermer"
$btnClose.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnClose.ForeColor = [System.Drawing.Color]::White
$btnClose.BackColor = [System.Drawing.Color]::Black
$btnClose.Size = New-Object System.Drawing.Size(200, 40)
$btnClose.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $btnClose.Width) / 2), $y)
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# Vérifier et créer le dossier JLS si nécessaire
if (!(Test-Path $scriptQS)) { New-Item -Path "C:\" -Name "JLS" -ItemType "directory" -Force } 

# Télécharger TeamViewerQS.exe si nécessaire
if (!(Test-Path $tvPath)) {
    Write-Host "TeamViewer QuickSupport absent. Téléchargement en cours..."
    try {
        Invoke-WebRequest -Uri $downloadURL -OutFile $tvPath -UseBasicParsing
        Write-Host "Téléchargement terminé. Lancement..."
        Start-Process $tvPath
    } catch {
        Write-Host "Erreur lors du téléchargement : $_"
    }
} else {
    Write-Host "TeamViewer QuickSupport déjà présent. Lancement..."
    Start-Process $tvPath
}

# Initialiser et démarrer le timer correctement
$timer = New-Object System.Diagnostics.Stopwatch
if ($timer -ne $null) {
    $timer.Start()
} else {
    Write-Host "Erreur : Timer non initialisé."
}

# Afficher la fenêtre
$form.ShowDialog()
