packer {
    required_plugins {
        qemu = {
            version = "~> 1"
            source  = "github.com/hashicorp/qemu"
        }
        vagrant = {
            version = "~> 1"
            source = "github.com/hashicorp/vagrant"
        }
        virtualbox = {
            version = "~> 1"
            source  = "github.com/hashicorp/virtualbox"
        }
    }
}

source "virtualbox-iso" "practice-vm" {
    vm_name = "practice-vm"
    guest_os_type = "Ubuntu_64"
    hard_drive_discard = true
    format = "ova"
    iso_url = "https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso"
    iso_checksum            = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"
    output_directory = "build"
    headless = true
    disk_size = 81920
    memory = 4096
    cpus = 4
    vboxmanage = [
        ["modifyvm", "{{.Name}}", "--vram", "128"]
    ]
    vrdp_bind_address = "0.0.0.0"
    communicator = "ssh"
    ssh_pty = true
    ssh_username = "ubuntu"
    ssh_password = "ubuntu"
    ssh_timeout = "10h"
    shutdown_command  = "echo 'ubuntu' | sudo -S shutdown -P now"
    shutdown_timeout = "10h"
    http_directory = "cloud-init"
    boot_command = [
        "<wait>e",
        "<wait><down><down><down><end><left><left><left><left> autoinstall ip=dhcp ds=nocloud\\;s=http://{{.HTTPIP}}:{{.HTTPPort}}/<wait><f10><wait>"
    ]
}

build {
    sources = ["sources.virtualbox-iso.practice-vm"]

    # Setup for development
    provisioner "shell" {
        inline = [
            # Disable auto-dimming the screen
            "gsettings set org.gnome.desktop.session idle-delay 0",

            # Enable dark mode by default
            "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'",

            # Fix the boot lagging issue (we already have NetworkManager)
            "echo 'ubuntu' | sudo -S systemctl disable systemd-networkd",

            # Setup Virtualbox clipboard
            "echo 'ubuntu' | sudo -S VBoxClient --clipboard",

            # Install additional tools
            "curl -L https://storage.googleapis.com/git-repo-downloads/repo > ~/repo",
            "echo 'ubuntu' | sudo -S mv ~/repo /bin/repo",
            "echo 'ubuntu' | sudo -S chmod a+x /bin/repo",

            # Configure git identity
            "git config --global user.name 'SCOPELAB'",
            "git config --global user.email 'whoami@scope.lab'",

            # Setup the optee project
            "echo 'Setting up the optee project...'",
            "mkdir optee && cd optee",
            "yes | repo init -u https://github.com/NTHU-SCOPELAB/cr-tee-manifest.git -m qemu_v8.xml",
            "repo sync",
            "rm -rf optee_examples/aes",

            # Setup scripts for compilation
            "echo 'Downloading setup scripts from HTTP server...'",
            "wget -O ~/setup-script.sh https://raw.githubusercontent.com/NTHU-SCOPELAB/cr-tee-lab/refs/heads/main/.github/build-image/cloud-init/setup-script.sh",

            # Clone the example
            "git clone https://github.com/NTHU-SCOPELAB/cr-tee-lab.git ~/aes"
        ]
    }

    # Optimize VM size
    provisioner "shell" {
        inline = [
            "echo 'ubuntu' | sudo -S apt-get autoremove",
            "echo 'ubuntu' | sudo -S apt-get clean",
            "echo 'ubuntu' | sudo -S rm -rf /var/log/*",
            "echo 'ubuntu' | sudo -S fstrim /"
        ]
    }
}
