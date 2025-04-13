# Ansible Basics

## What is Ansible?

- Ansible is a configuration management tool written in **YAML** format.
- When we need to automate configuration changes across many servers at once with minimal effort, Ansible simplifies this process.
  
### Example Scenario
- Consider a scenario where we have 100 servers. If we want to update an existing package or copy a file to all these servers, we can write Ansible playbooks to automate this task.

### Why Use Ansible?
- You might ask, "Why use Ansible when we can copy files using a shell script or other automation tools?"
- Imagine out of 100 servers, 40 are Linux, 40 are Ubuntu, and the remaining 20 are Windows. 
- A shell script written for the **YUM** package manager will only work on the 40 Linux machines, but not on Ubuntu or Windows servers.
- Ansible, **Chef**, **Puppet**, and **Salt** solve this problem by allowing us to group servers based on their type and run tasks accordingly. 
    - For example, we can use **YUM** for Linux servers, **APT** for Ubuntu servers, and **CHOCO** (Chocolatey) for Windows servers.
- Ansible connects to the Linux/Unix based machines using **SSH** and windows servers using **Winrm**.

### Why Ansible Over Puppet and Chef?
- Ansible is preferred over **Puppet** and **Chef** because those are **agent-based** services, requiring agents to be installed on each managed server. 
- **Ansible**, on the other hand, is **agentless**, meaning there’s no need to install agents on target machines. It only requires SSH (or WinRM for Windows), making it simpler and faster to set up.

## Ansible Architecture

In Ansible, there are two types of nodes:

1. **Control Node**: 
   - Ansible is installed on this one machine, which manages the configuration of all the other servers (called managed nodes).
   
2. **Managed Nodes**: 
   - These are the servers being managed by the control node. In our example, these are the 100 servers that Ansible is automating tasks for.

## Ansible Use Cases

1. **Configuration Management**:  
   - Ansible can be used to manage configurations across multiple servers, ensuring consistency.

2. **Resource Provisioning**:  
   - Ansible can be used to provision resources, such as creating virtual machines or containers.

3. **CI/CD**:  
   - Ansible is commonly used in Continuous Integration and Continuous Deployment (CI/CD) pipelines to deploy artifacts to target machines. It can deploy to multiple Kubernetes clusters or multiple servers for monolithic applications.

4. **Network Automation**:  
   - Ansible can also be used to automate network configurations, making it a powerful tool for managing network infrastructure. 
   - Companies that have networking appliances/tools on-prem like firewalls, routers, loadbalancer, etc. We can use ansible, we can talk and automate the network appliances like VLAN.

## <a href="https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html">Installing Ansible</a>
- On the control nodes and managed nodes we need to have python installed.
- On Control node we need to install ansible
- Why python on managed nodes? Ansible is written in YAML, these YAML files are converted in python code and executs the python modules on managed nodes.
- Except for Windows, ansible works only with python. In windows machine WSL is a requirement.
```bash
sudo apt install -y python3-pip
sudo apt install ansible
```
---

## Key Components in Ansible

### Inventory
- Ansible inventory can be written in 2 formats, either in invetory.ini or inventory.yml.

### Password based Authentication
- Lets enable password make authentication
```bash
sudo sed -i 's|PasswordAuthentication no|PasswordAuthentication yes|'g /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
or
sudo sed -i 's|#PasswordAuthentication yes|PasswordAuthentication yes|g' /etc/ssh/sshd_config
sudo systemctl restart ssh
sudo passwd ubuntu
```

### Role Based Access
- Create an IAM Role and attach it to the Ansible Control Node and attach it to Ansible Control Node
```bash
aws sts get-caller-identity #verify role is attached
```

### Passwordless Authentication
- We will create an inventory file, inventory.ini that will contain all information about our hosts.
```yaml
all:
   hosts:
      node1:
         ansible_user: ubuntu
         ansible_host: {PRIVATE/PUBLIC}IP
         ansible_ssh_private_key_file: KEYFILE.PEM
```
```bash
ansible -i inventory.yml -m ping all
```
- To disable **Host Key verification**, we have to create /etc/ansible/ansible.cfg
- If you dont see that file, upgrade ansible. Also, If you want to keep your OS secure from Ansible dependencies work within virtual environment
```bash
python3 -m venv ~/ansible-venv
source ~/ansible-venv/bin/activate
pip install --upgrade pip
pip install ansible
pip3 install --upgrade ansible
```
- To generate ansible configuration file
```bash
sudo -i
cd /etc/ansible
ansible-config init --disabled -t all > ansible.cfg
mv ansible.cfg ansible.cfg.bkp
sudo sed -i 's|;host_key_checking=True|host_key_checking=False|g' ansible.cfg # DISABLES HOST KEY VERIFICATION, IGNORES DO YOU WANT TO CONNECT(YES/NO?)
```





