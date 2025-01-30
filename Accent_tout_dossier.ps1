# Fonction pour supprimer les accents
function Remove-Accents {
    param (
        [Parameter(Mandatory = $true)]
        [string]$inputString
    )
    # Normalisation Unicode en FormD
    $normalizedString = $inputString.Normalize([Text.NormalizationForm]::FormD)
    # Supprimer les caractères diacritiques (accents)
    $regex = [Regex]::Replace($normalizedString, '\p{Mn}', '')
    return $regex
}

# Chemin relatif ou absolu vers le dossier parent
$parentFolderPath = ".\data"

# Fonction pour renommer fichiers et dossiers récursivement
function Rename-Recursively {
    param (
        [Parameter(Mandatory = $true)]
        [string]$path
    )

    # Parcourir tous les fichiers et dossiers dans le chemin
    Get-ChildItem -Path $path -Recurse | ForEach-Object {
        $currentName = $_.Name
        $currentPath = $_.FullName

        # Appliquer la suppression des accents au nom
        $newName = Remove-Accents -inputString $currentName

        # Vérifier si le nom a changé et renommer
        if ($currentName -ne $newName) {
            try {
                Rename-Item -Path $currentPath -NewName $newName -Force
                Write-Host "Renommé : '$currentName' -> '$newName'"
            } catch {
                Write-Host "Erreur lors du renommage de '$currentName' : $_" -ForegroundColor Red
            }
        } else {
            Write-Host "Aucun changement nécessaire pour : '$currentName'"
        }
    }
}

# Appel de la fonction pour renommer récursivement
Rename-Recursively -path $parentFolderPath
