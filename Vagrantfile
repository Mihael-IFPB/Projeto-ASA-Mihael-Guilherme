# Projeto Adminstração de Sistemas Abertos - Mihael e Guilherme
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.ssh.insert_key = false

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.check_guest_additions = false
  end

  # Serv arq
  config.vm.define "arq" do |arq|
    arq.vm.hostname = "arq.mihael.guilherme.devops"
    arq.vm.network "private_network", ip: "192.168.56.112"

    arq.vm.provider "virtualbox" do |vb|
      vb.memory = 512
    end

    (0..2).each do |x|
      arq.vm.disk :disk, size: "10GB", name: "disk-#{x}"
    end

    arq.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "provisionamento.yml"
    end
  end

  # Serv db
  config.vm.define "db" do |db|
    db.vm.hostname = "db.mihael.guilherme.devops"
    db.vm.network "private_network", type: "dhcp", mac: "aabbccddee01"
    db.vm.provider "virtualbox" do |vb|
      vb.memory = 512
    end

    db.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "provisionamento.yml"
    end
  end

  # Serv app
  config.vm.define "app" do |app|
    app.vm.hostname = "app.mihael.guilherme.devops"
    app.vm.network "private_network", type: "dhcp", mac: "aabbccddee02"
    app.vm.provider "virtualbox" do |vb|
      vb.memory = 512
    end

    app.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "provisionamento.yml"
    end
  end

  # Cliente (cli)
  config.vm.define "cli" do |cli|
    cli.vm.hostname = "cli.mihael.guilherme.devops"
    cli.vm.network "private_network", type: "dhcp"
    cli.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end

    cli.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "provisionamento.yml"
    end
  end
end


