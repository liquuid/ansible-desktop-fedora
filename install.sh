sudo dnf install ansible
ansible-galaxy collection install community.general
ansible-playbook -i hosts workstation.yml 