# External Modules
- In this I will use external modules and not **ansible.builtin**.
- Some modules need python dependencies.
- Ansible coverts YAML files into python scripts and dump them on target host.
- So some dependencies has to be installed on the target machine.
- External modules have to be installed on Ansible host
```bash
ansible-galaxy collection isntall community.mysql
```

## <a href="https://docs.ansible.com/ansible/latest/collections/index_module.html#community-mysql">Mysql on target machine</a>
- We need to install python mysql on target machines
- Search for python mysql package
```bash
apt search python | grep -i mysql # python3-mysqldb/jammy 1.4.6-1build1 amd64
```
- Install it first in the playbook then install mysql
- For isntalling database, Sometime you need to mention socket file location.
- **Socket Files** in linux is used to connect processes together. If one process wants to connect to another it uses socket file. Python to connect with Mysql it needs the **Socket File** location
```yaml
- name: Install dependencies for MySQL
      ansible.builtin.apt:
        name: python3-mysqldb
        state: present
    - name: Create MySQL database with name accounts
      community.mysql.mysql_db:
        name: accounts
        state: present
        # login_unix_socket: /var/run/mysqld/mysqld.sock #if running on Linux
    - name: Create database user with name 'aditya' and password '12345' with all database privileges
      community.mysql.mysql_user:
        name: aditya
        password: 12345
        priv: '*.*:ALL'
        state: present
```
- To verify,
```bash
mysql -u aditya -p accounts #ENTER PASSWORD 12345
```