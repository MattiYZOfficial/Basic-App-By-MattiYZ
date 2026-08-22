import subprocess
import sys
import ctypes

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

if not is_admin():
    # Riavvia lo script come amministratore se non lo è già
    script = sys.executable
    parameters = ' '.join([f'"{arg}"' for arg in sys.argv])
    ctypes.windll.shell32.ShellExecuteW(None, "runas", script, parameters, None, 1)
    sys.exit()

def install_chocolatey():
    print("Controllo se Chocolatey è installato...")
    choco_check = subprocess.run(["where", "choco"], capture_output=True, text=True)
    if choco_check.returncode != 0:
        print("Chocolatey non trovato. Installazione in corso...")
        install_cmd = (
            "Set-ExecutionPolicy Bypass -Scope Process -Force; "
            "[System.Net.ServicePointManager]::SecurityProtocol = "
            "[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; "
            "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        )
        subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", install_cmd], shell=True)
    else:
        print("Chocolatey è già installato.")

def main():
    print("=== Installatore Applicazioni Base ===")
    install_chocolatey()

    apps = [
        "googlechrome",
        "firefox",
        "7zip",
        "vlc",
        "discord",
        "vscode",
        "telegram",
        "steam"
    ]

    print("\nInizio installazione delle applicazioni...")
    for app in apps:
        print(f"\nInstallazione di {app} in corso...")
        result = subprocess.run(["choco", "install", app, "-y"], shell=True)
        if result.returncode == 0:
            print(f"{app} installato con successo!")
        else:
            print(f"Errore durante l'installazione di {app}.")

    print("\nProcesso di installazione completato!")
    input("\nPremi INVIO per uscire...")

if __name__ == "__main__":
    main()
