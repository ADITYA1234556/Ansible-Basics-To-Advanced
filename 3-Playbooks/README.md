# Ansible Playbooks
- While Ad-Hoc commands are meant for one task per command, Playbooks can help us run multiple tasks.
- List of all the modeules in <a href="https://docs.ansible.com/ansible/latest/collections/index_module.html">Ansible</a>

## Playbook Structure
```yaml
---
- name: Control Plane setup of 1 server
  become: yes
  hosts: master_nodes
  tasks:
  - name: Install Apache
    ansible.builtin.apt:
      name: apache2
      state: latest
  - name: Start Service
    ansible.builtin.service:
      name: apache2
      state: started
      enabled: yes
  - name: Copy file
    ansible.builtin.copy:
      src: index.html
      dest: /var/www/html 
- name: Worker node setup of 2 server
  become: yes
  hosts: worker_nodes
  tasks:
  - name: Install Apache
    ansible.builtin.apt:
      name: apache2
      state: latest
  - name: Start Service
    ansible.builtin.service:
      name: apache2
      state: started
      enabled: yes
  - name: Copy file
    ansible.builtin.copy:
      src: index.html
      dest: /var/www/html
```
- Run the playbook
```bash
ansible-playbook -i inventory playbook.yml #name of the playbook.yml
# Changed: config changed
# OK: Nothing to do, already applied IDEMPOTENCY
ansible-playbook -i inventory playbook.yml -v #debug
ansible-playbook -i inventory playbook.yml -vvvv # can go upto 4 times v for more verbose
ansible-playbook -i inventory playbook.yml --syntax-check # checks syntax and points where the issue is
ansible-playbook -i inventory playbook.yml -C # Dry run, to run before actually executing the playbook
```