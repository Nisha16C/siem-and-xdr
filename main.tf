## assign static ip
// resource "cloudstack_static_nat" "vm1_static_ip" {
//   virtual_machine_id = cloudstack_instance.vm1.id
//   ip_address         = "192.168.30.54"
// }

// resource "cloudstack_static_nat" "vm2_static_ip" {
//   virtual_machine_id = cloudstack_instance.vm2.id
//   ip_address         = "192.168.30.53"
// }

## create vms

resource "cloudstack_instance" "vm1" {
  name             = "soc"
  service_offering = "test-vm1"
  template         = "ub20.04-no-disk-raw-kvm-amd64.img"
  zone             = "WIPL-bz4"
  network_id       = "182f40ba-1b00-4729-bd4f-a7e9a2f33c11"
  security_group_ids = ["c3547800-2d43-454b-93df-59c1013f78e3"]
  keypair          = "rdp"
  #ip_address       = "192.168.30.70"
  expunge          = "true"
  user_data = <<-EOF
  #USER DATA
  user: ubuntu
  password: ubuntu
  chpasswd:
      expire: false
  ssh_pwauth: true
  package_update: true
  packages:
    - qemu-guest-agent
    - apt-transport-https
    - curl
  runcmd:
    - echo 'hello'

  EOF
}

// resource "cloudstack_instance" "vm2" {
//   name             = "backend-vm"
//   service_offering = "test-vm1"
//   template         = "ub20.04-no-disk-raw-kvm-amd64.img"
//   zone             = "WIPL-bz4"
//   network_id       = "182f40ba-1b00-4729-bd4f-a7e9a2f33c11"
//   security_group_ids = ["c3547800-2d43-454b-93df-59c1013f78e3"]
//   keypair          = "rdp"
//   ip_address       = "192.168.30.71"
//   expunge          = "true"
// }
