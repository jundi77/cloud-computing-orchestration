# cloud-computing-orchestration
Cloud orchestration using either opentofu or ansible and achieve similar results. The goal is to understand declarative and imperative way in IaaC.

Here is the code created in implementing the task:
- Ansible
    - `ansible/create.yml`: Ansible playbook file for system provisioning and running VMs. The steps given are to prepare the libvirt pool, create a cloud-init ISO for both VMs, copy the ubuntu cloud OS to the pool, create images for both VMs in the pool, prepare the VMs, and run the VMs based on the libvirt XML configuration file.

    - `ansible/destroy.yml`: Ansible playbook file to remove everything prepared and done in ansible/create.yml.

    - `ansible/vars.yml`: Variables required by ansible/create.yml and ansible/destroy.yml.

    - `ansible/create.sh`: Script to run ansible/create.yml.

    - `ansible/destroy.sh`: Script to run ansible/destroy.yml.

    - `ansible/hosts`: Hosts used by the ansible playbook.

- Libvirt
    - `domain/db.xml.j2`: Libvirt configuration file for VM db.

    - `domain/webserver.xml.j2`: Libvirt configuration file for VM webserver.

    - `pool/ubuntu_cluster.xml.j2`: Libvirt configuration file for the pool used.

- Opentofu
    - `opentofu/main.tf`: Opentofu file for system provisioning and running VMs. Contains infrastructure definitions in the form of desired results. The definitions given are for the libvirt pool, cloud-init ISO for both VMs, the ubuntu cloud OS used, images for both VMs, and VM configurations. The infrastructure is created with the tofu apply command and to delete the infrastructure with the tofu destroy command.

    - `opentofu/variables.tf`: Variables used when running Opentofu.

    - `opentofu/outputs.tf`: Output given by Opentofu.

    - `opentofu/provider.tf`: Configuration of the provider used when running Opentofu.

- Cloud-init
    - `config/cloud-init/db/user-data`: Steps run inside the database VM, installing apache2 and phpmyadmin with the apt repository automatically using debconf-set-selections.
    - `config/cloud-init/webserver/user-data`: Steps run inside the webserver VM, installing apache2 and downloading web files using git, then moving the files to /var/www/html.
- Other tools
    - `images/download.sh`: Script to download ubuntu cloud noble-server