#!/bin/bash

# $1 is a special positional arg used by Coriolis to identify the OS root mountpoint
rootDiskPath="$1"

# make sure /etc/cloud exists
mkdir -p "$rootDiskPath/etc/cloud"

# overwrite cloud-init's cloud.cfg to not wreck the vm
path="$rootDiskPath/etc/cloud/cloud.cfg"
cat << EOH > $path
disable_root: 0
ssh_pwauth: unchanged
ssh_deletekeys: 0
chpasswd: {expire: False}
users:
  - default

mount_default_fields: [~, ~, 'auto', 'defaults,nofail,x-systemd.requires=cloud-init.service', '0', '2']
resize_rootfs_tmp: /dev
disable_vmware_customization: false
preserve_hostname: true

cloud_init_modules:
 - disk_setup
 - migrator
 - bootcmd
 - write-files
 - growpart
 - resizefs
 - set_hostname
 - rsyslog

cloud_config_modules:
 - mounts
 - locale
 - set-passwords
 - rh_subscription
 - yum-add-repo
 - package-update-upgrade-install
 - timezone
 - puppet
 - chef
 - salt-minion
 - mcollective
 - disable-ec2-metadata
 - runcmd

cloud_final_modules:
 - rightscale_userdata
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - keys-to-console
 - phone-home
 - final-message
 - power-state-change

system_info:
  distro: rhel
  paths:
    cloud_dir: /var/lib/cloud
    templates_dir: /etc/cloud/templates
  ssh_svcname: sshd

# vim:syntax=yaml
EOH

# Delete the old network interface files, cloud-init will make a new one
rm -f $rootDiskPath/etc/sysconfig/network-scripts/*

# Leave an indicator that this did run correctly
touch "$rootDiskPath/etc/.is-migrated"
