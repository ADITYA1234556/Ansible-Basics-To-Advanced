# Ansible Vault
- Ansible Vault allows you to store secrets.
- To create an ansible vault, So we can use this vault to store all secrets.
``bash
ansible-vault create myansiblesecrets/my_vault.yaml
.
├── ansible.cfg
├── inventory.yaml
└── myansiblesecrets
    └── my_vault.yaml
```
- I added a secret into my_vault.yaml
```yaml
ssh_private_key_for_ubuntu_machines: "-----BEGIN RSA PRIVATE KEY-----
asdmasdioionfiaon912425t9ejwe90f8023yu598hgfionhiosdaf
-----END RSA PRIVATE KEY-----"
```
- Trying to read the secret
```bash
cat myansiblesecrets/my_vault.yaml ## AES Encrypted data 
```
- Actual way to view the secret, will ask the password that we set when we created the vault
```bash
ansible-vault view myansiblesecrets/my_vault.yaml
ansible-vault edit myansiblesecrets/my_vault.yaml
```
- Now using this secret in playbook or adhoc commands
```yaml
all:
  hosts:
    control_node:
      ansible_host: 127.0.0.1
    node01:
      ansible_host: 172.31.42.95
    node02:
      ansible_host: 172.31.34.45
  children:
    master_nodes:
    hosts:
        control_node:
    worker_nodes:
    hosts:
        node01:
        node02:
    servers:
      children:
        master_nodes:
        worker_nodes:
      vars:
        ansible_user: ubuntu
        ansible_ssh_private_key_file: ssh_private_key_for_ubuntu_machines
```
```bash
ls
ansible.cfg  inventory.yaml  myansiblesecrets
ansible -i inventory.yaml -m ping all -e @myansiblesecrets/my_vault.yaml --ask-vault-pass
```
- To change the password for Ansible vault
```bash
ansible-vault rekey myansiblesecrets/my_vault.yaml
```

## Creating ansible vault with base64 randomly generated secret file
- Lets create a bse64 randomly generated file that we will use for authenticating with ansible vault
```bash
openssl rand --base64 2048 > ansible-vault.pass
```
- Let us create a new vault now with this file
```bash
ansible-vault create myansiblesecrets/my_vault_base64.yaml --vault-password-file=ansible-vault.pass
ubuntu_uname: "ubunutu"
ubuntu_key: "asdasd"
```
- To view the secret inside this new vault file
```bash
ansible-vault view myansiblesecrets/my_vault_base64.yaml --vault-password-file=ansible-vault.pass
```
- To use this secret with ansible commands, My inventory file that uses key names of secrets stored in ansible-vault
```yaml
all:
  hosts:
    control_node:
      ansible_host: 127.0.0.1
      ansible_user: ubuntu_uname
      ansible_ssh_private_key_file: ubuntu_key
    node01:
      ansible_host: 172.31.42.95
      ansible_user: ubuntu_uname
      ansible_ssh_private_key_file: ubuntu_key
    node02:
      ansible_host: 172.31.34.45
      ansible_user: ubuntu_uname
      ansible_ssh_private_key_file: ubuntu_key
```
- To use the secret with my inventory file
```bash
ansible-vault -i inventory.yaml -m ping all -e @myansiblesecrets/my_vault_base64.yaml --vault-password-file=ansible-vault.pass
```
