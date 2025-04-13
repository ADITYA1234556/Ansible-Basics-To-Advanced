# Grouped Inventory and Ad-Hoc Commands
- Previously we saw how we can set up ansible master and control nodes, and how to communicate with the servers using ansible inventory file and AD-HOC commands (ansible -i inventory -m ping all)
- Now we will see Grouped Inventory and Playbooks.
- Ansible is **IdemPotent** once a state is changed, it will be the same if we re run the command it will not do anything, "changed": false

## Grouped Inventory
- The best part of ansible is grouped hosts
```yaml
all:
    hosts:
        master_node:
            ansible_user: ubuntu
            ansible_host: IP
            ansible_ssh_private_key_file: key.pem
        node1:
            ansible_user: ubuntu
            ansible_host: IP
            ansible_ssh_private_key_file: key.pem
        node2:
            ansible_user: ubuntu
            ansible_host: IP
            ansible_ssh_private_key_file: key.pem
    children:
        control_plane:
            master_node:
        worker_nodes:
            node1:
            node2:
        group_of_group:
            master_node:
            worker_nodes:     
```
```bash
ansible -i inventory control_plane -m ping # To execute on all the hsots under control_plane
ansible -i inventory worker_nodes -m ping # To execute on all the hsots under worker_nodes
ansible -i inventory group_of_group -m ping # To execute on all the hsots under group_of_group
ansible -i inventory all -m ping # To execute on all the hsots 
ansible -i inventory 'node*' -m ping # To execute on all the hsots that starts with node
```

## Variables
- If we are going to reuse some lines of code, we can use variables.
- Variables has priority
1. Host level has highest priority/ precedence.

```yaml
all:
    hosts:
        master_node:
            ansible_user: ubuntu
            ansible_host: IP
            ansible_ssh_private_key_file: key.pem
        node1:
            ansible_user: ubuntu
            ansible_host: IP
            ansible_ssh_private_key_file: key.pem
        node2:
            ansible_user: ubuntu
            ansible_host: IP
            ansible_ssh_private_key_file: key.pem
    children:
        control_plane:
            master_node:
        worker_nodes:
            node1:
            node2:
        group_of_group:
            children:
                master_node:
                worker_nodes: 
            vars:
                ansible_ssh_private_key_file: key.pem
                ansible_user: ubuntu
```

### AD-HOC Commands
1. **YUM/APT**: ansible.builtin.yum / ansible.builtin.apt - package manager module. **Needs to be run as root user**
```bash
ansible.builtin.yum -a "name=httpd state=present" 
ansible -i inventory -m ansible.builtin.yum -a "name=httpd state=present" control_node # will throw permission issue
ansible -i inventory -m ansible.builtin.yum -a "name=httpd state=present" control_node --become # Will install httpd
ansible -i inventory -m ansible.builtin.apt -a "name=apache2 state=present" control_node # will throw permission issue
ansible -i inventory -m ansible.builtin.apt -a "name=apache2 state=present" control_node --become # "changed": true # Will install Apache2
ansible -i inventory -m ansible.builtin.apt -a "name=apache2 state=present" control_node --become # "changed": false - IDEMTPOTENCY
ansible -i inventory -m ansible.builtin.apt -a "name=apache2 state=absent" control_node --become # "changed": true - Difference in state
```
2. **SERVICE**: ansible.builtin.service -- checks the service status
```bash
ansible -i inventory -m ansible.builtin.service -a "name=httpd state=started enabled=yes" control_node # Starts and enables httpd
ansible -i inventory -m ansible.builtin.service -a "name=apache2 state=started enabled=yes" control_node # Starts and enables apache2
```
3. **COPY**: ansible.builtin.copy -- Copies a file
```bash
echo "This is managed by Ansible" >> index.html
ansible -i inventory -m ansible.builtin.copy -a "src=index.html dest=/var/www/html" -i inventory servers --become # will copy index.html from current work dir to dest servers at /var/www/html
ansible -i inventory -m ansible.builtin.copy -a "src=index.html dest=/var/www/html" -i inventory servers --become #"changed": false IDEMPOTENCY, No changes to source file nothing to do.
echo "Another line" >> index.html
ansible -i inventory -m ansible.builtin.copy -a "src=index.html dest=/var/www/html" -i inventory servers --become # Will make a change, ansible detects file changes "changed": true
```
4. **FILE**: ansible.builtin.file -- Checks if a file is present or not
```bash
ansible -i inventory.yml -m ansible.builtin.file -a "path=/var/www/index.html state=file" all --become # FILE - Checks if a file is present "msg": "file (/var/www/index.html) is absent, cannot continue"
ansible -i inventory.yml -m ansible.builtin.file -a "path=/var/www/index.html state=absent" all --become # ABSENT - removes the file from the location
```

## Ansible Config
- Ansible configuration are settings that ansible uses
- For instance, for security reasons if we changed the SSH port number from 22 to 3389 then we can modify ansible configurations to not use the default settings of port 22 for SSH rather use our custom configuration and will use port 3389 for SSH. 
- Ansible configurations have precedence or priority. It is as follow:
1. **ANSIBLE_CONFIG** - create a file in any location and export ANSIBLE_CONFIG="/home/ubunutu/ansible/ansible.cf"
2. **ansible.cfg** - Ansible.cfg present in the project directory or current working directory.
3. **~./.ansible.cfg** - The hidden file we create in the home directory
4. **Global level** - /etc/ansible/ansible.cfg - has the last priority, if we havent configured ansible.cfg in the above spots this will be considered.
- Most used in **ansible.cfg** in the current directory, as it can be pushed to version control system like GitHub along with playbooks and inventory file to github so anyone who clones the repo also get the ansible configuration along with playbook and inventory.