import subprocess
import os

def main():
    os.system('clear')

    url = "https://raw.githubusercontent.com/DindaPutriFN/DindaPutriFN/main/openvpn/install.sh"
    subprocess.run(['wget', '-q', url])

    subprocess.run(['chmod', '+x', 'install.sh'])

    subprocess.run(['./install.sh'])

    subprocess.run(['rm', '-fr', 'install.sh'])

if __name__ == "__main__":
    main()