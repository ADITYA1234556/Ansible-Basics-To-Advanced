# ANSIBLE ROLES
- <a href="https://galaxy.ansible.com/ui/standalone/roles/">Ansible roles</a> are a way to organize our playbooks and make automation code cleaner, reusable, and modular.
- Also we can share the ansible roles within and outside the organization.
- By using Ansible roles, at times we can save ourselves from writing complex playbooks. By reusing a role and maybe customizing if needed and configure the target machines. 

## How to use Ansible galaxy roles and Collections
- Similar to DockerHub which hosts all our docker images and for this we need **Docker cli**
- Ansible-Galaxy has all the roles or modules and playbooks for which we need **ansible-galaxy**. Most times we get ansible-galaxy installed with ansible itself. Verify
```bash
ansible-galaxy -h
```
- It should give us two types
1. Collection
2. Roles
```bash
ansible-galaxy role -h
ansible-galaxy collection -h
```

## How to use Ansible roles
- To use an ansible role, we use the command
```bash
ansible-galaxy init rolename
```
- When we create a ansible role for httpd it will give us a complete structure 
```bash
ansible-galaxy init httpd
cd httpd
tree .
.
├── README.md
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```
- I am going to install docker on target machines so I am going to use a Ansible role created and published by <a href="https://galaxy.ansible.com/ui/standalone/roles/bsmeding/docker/">bsmeding</a>
- - To use Ansible roles published by community,
```bash
ansible-galaxy role install bsmeding.docker
ls ~/.ansible/roles/ # To list all the roles installed
tree ~/.ansible/roles/bsmeding.docker/
/home/ubuntu/.ansible/roles/bsmeding.docker/
├── LICENSE
├── README.md
├── defaults
│   └── main.yml
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── molecule
│   └── default
│       ├── converge.yml
│       ├── molecule.yml
│       └── verify.yml
├── requirements.yml
├── tasks
│   ├── docker-compose.yml
│   ├── docker-users.yml
│   ├── main.yml
│   ├── setup-Debian.yml
│   └── setup-RedHat.yml
├── templates
│   └── http-proxy.conf.j2
└── vars
    ├── Alpine.yml
    ├── Archlinux.yml
    ├── Debian.yml
    ├── RedHat.yml
    └── main.yml
```
- Once the role is here, We can use this role in our playbooks
```bash
ansible-playbook -i inventory 1-role-playbooks.yml
```

## How to publish Ansible roles to Ansible Galaxy?
- Sign in to <a href="https://galaxy.ansible.com/ui/">Ansible Galaxy</a>
- If we register we can publish our own roles to ansible and use it.
- To publish ansible roles, we have to push the project directory to github and import from github into galaxy roles.
- Intializing an ansible role and pushing to GitHub
```bash
ansible-galaxy init mycustomtole
cd mycustomrole
git add .
git commit -m "ansible roles"
git push GITREPO
```
- Authenticating with Ansible Galaxy to push the custom role to Ansible Galaxy. Go to Collection -> API Token -> "ANSIBLE TOKEN"
```bash
ansible-galaxy import ADITYA1234556 GITREPONAME --token APITOKEN
# ansible-galaxy import ADITYA1234556 Ansible-Basics-To-Advanced --token hv4j23v4hj234vbhj1hj3
```
- This step will push our custom ansible role to ansible galaxy and from there any one can use this.

## How to create custom Ansible role
- **Note**: Ansible custom roles are not required, Unless we have complicated automation tasks. For example, if we have a task like installing and configuring kuberentes cluster that is created using terraform then we can create custom roles. So that terraform will spin up the instances and ansible will pick up from there and configure these instance to set up kuberentes. 
- We should still try to find roles that are already available in ansible galaxy, if it doesn't we can create our custom roles.
- So we can create our custom role that can be shared among our organization.
- Follow these steps to create a custom ansible role
```bash
ansible-galaxy role init mycustomrole # Will create a directory with starting structure for roles
.
├── index.html
├── inventory.yml
└── mycustomrole
    ├── README.md
    ├── defaults
    │   └── main.yml
    ├── files
    ├── handlers
    │   └── main.yml
    ├── meta
    │   └── main.yml
    ├── tasks
    │   └── main.yml
    ├── templates
    ├── tests
    │   ├── inventory
    │   └── test.yml
    └── vars
        └── main.yml
```
- Now we can start, writing our playbooks and update README.md to briefly explain about the custom role.
- Once the directory has been changed with required tasks, and values.
```bash
ansible-playbook -i inventory.yml playbook.yml
```
```yaml
---
- hosts: all
  become: true
  roles:
   - mycustomrole #name of customrole
```
- This playbook will run what our custom role is meant to do. 

## Project Structure information.
- **Defaults**: Are same like variables. If we dont mention values in variables/main.yml, values inside defaults/main.yml will be used. Values/main.yml can be used to override the default values.
- **Templates**: Similar to files, only difference is that when we have files that has dynamic values.  {{ ansible_facts['hostname'] }}
- **Handlers**: Handlers are tasks that gets executed based on a previous task and its ID.
- **Meta**: Metadata of the role, like owner info, etc.
- **Tasks**: Will contain all the tasks that should be executed on targets.
- **Tests**
- **Vars**: Stores all variables.
- **Files**: All the files like **index.html**, **data.csv**, **custom.yml** etc. and any files that needed to be copied can be placed inside this folder. This way, we can make the project structure more understandable for everyone. Say if we had some **.yml** files in the project directory, another person can get confused with that as a playbook. So we can move those files into Files directory so that we can differentiate, which is playbooks and which are files to be copied. Inside the tasks, we can refer it as **src:files/index.html**
- The tasks inside handler will only be executed if template config file task is successful or had some change = true
```yaml
tasks:
- name: Template config file
  ansible.builtin.template:
    src: template.js
    dest: /etc/foo.conf
  notify:
    - Restart apache 
    - Restart memcached
handlers:
  - name: Restart memcached
    ansible.builtin.service:
      name: memcached
      state: restarted
  - name: Restart apache 
    ansible.builtin.service:
      name: apache
      state: restarted
```
