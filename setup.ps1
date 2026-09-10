Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Verifica e installazione automatica di Chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installazione di Chocolatey in corso..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
}

# Creazione della Finestra GUI
$form = New-Object System.Windows.Forms.Form
$form.Text = "MattiYZ Utility & Setup"
$form.Size = New-Object System.Drawing.Size(380, 480)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Text = "Seleziona le applicazioni da installare:"
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.AutoSize = $true
$form.Controls.Add($label)

# Lista delle app
$apps = @(
    @{ Name = "Google Chrome"; Id = "googlechrome" },
    @{ Name = "Mozilla Firefox"; Id = "firefox" },
    @{ Name = "7-Zip"; Id = "7zip" },
    @{ Name = "Visual Studio Code"; Id = "vscode" },
    @{ Name = "VLC Media Player"; Id = "vlc" },
    @{ Name = "Git"; Id = "git" },
    @{ Name = "Discord"; Id = "discord" },
    @{ Name = "Spotify"; Id = "spotify" }
)

$checkboxes = @()
$yOffset = 50
foreach ($app in $apps) {
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $app.Name
    $chk.Tag = $app.Id
    $chk.Location = New-Object System.Drawing.Point(30, $yOffset)
    $chk.AutoSize = $true
    $form.Controls.Add($chk)
    $checkboxes += $chk
    $yOffset += 30
}

# Bottone di avvio
$btnInstall = New-Object System.Windows.Forms.Button
$btnInstall.Text = "Avvia Setup"
$btnInstall.Location = New-Object System.Drawing.Point(120, $yOffset + 20)
$btnInstall.Size = New-Object System.Drawing.Size(130, 40)
$btnInstall.Add_Click({
    $form.Close()
    
    # Installazione app selezionate
    foreach ($chk in $checkboxes) {
        if ($chk.Checked) {
            Write-Host "Installazione di $($chk.Text)..." -ForegroundColor Cyan
            choco install $chk.Tag -y
        }
    }
    
    # Attivazione Windows/Office con MAS
    Write-Host "Apertura script di attivazione MAS..." -ForegroundColor Green
    irm https://get.activated.win | iex
})

$form.Controls.Add($btnInstall)
[void]$form.ShowDialog()
