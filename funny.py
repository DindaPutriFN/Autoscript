import subprocess
import os

def main():
    os.system('clear')

    url = "https://github.com/DindaPutriFN/Autoscript/releases/download/1.6/install.sh"
    subprocess.run(['wget', '-q', url])

    subprocess.run(['chmod', '+x', 'install.sh'])

    subprocess.run(['./install.sh'])

    subprocess.run(['rm', '-fr', 'install.sh'])

if __name__ == "__main__":
    main()