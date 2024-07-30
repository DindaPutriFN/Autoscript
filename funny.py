import subprocess
import os

def main():
    os.system('clear')

    url = "https://raw.githubusercontent.com/DindaPutriFN/DindaPutriFN/main/openvpn/setup.sh"
    subprocess.run(['wget', '-q', url])

    subprocess.run(['chmod', '+x', 'setup.sh'])

    subprocess.run(['./setup.sh'])

    subprocess.run(['rm', '-fr', 'setup.sh'])

if __name__ == "__main__":
    main()