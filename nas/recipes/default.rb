#
# Cookbook Name:: nas
# Recipe:: default
# Author:: KIMATA Tetsuya <kimata@green-rabbit.net>
#
# Copyright 2013, KIMATA Tetsuya
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

################################################################################
# apcups
package 'apcupsd'

service 'apcups' do
  service_name 'apcupsd'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/apcupsd/apcupsd.conf' do
  source    'apcups/apcupsd.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[apcups]'
end

template '/etc/default/apcupsd' do
  source    'apcups/apcupsd.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[apcups]'
end

################################################################################
# dhcp
template '/etc/dhcp/dhclient.conf' do
  source    'dhcp/dhclient.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
end

################################################################################
# hdparm
package 'hdparm'

template '/etc/hdparm.conf' do
  source    'hdparm/hdparm.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
end

################################################################################
# ipmi
package 'ipmitool'

template '/etc/modules' do
  source    'modprobe/modules.erb'
  owner     'root'
  group     'root'
  mode      '0644'
end

template '/etc/modprobe.d/ipmi.conf' do
  source    'modprobe/ipmi.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
end

################################################################################
# locate
template '/etc/updatedb.conf' do
  source    'locate/updatedb.conf.erb'
  owner     'root'
  group     'root'
  mode      '0440'
end

################################################################################
# mount
directory '/storage' do
  owner     'root'
  group     'root'
  mode      '0755'
  action    :create
end

template '/etc/fstab' do
  source    'mount/fstab.erb'
  owner     'root'
  group     'root'
  mode      '0440'
  notifies  :run, 'execute[mount]'
end

execute 'mount' do
  command   'mount -a'
  action    :nothing
end

################################################################################
# network
template '/etc/hosts' do
  source    'network/hosts.erb'
  owner     'root'
  group     'root'
  mode      '0644'
end

template '/etc/network/interfaces' do
  source    'network/interfaces.erb'
  owner     'root'
  group     'root'
  mode      '0644'
end

################################################################################
# ntp
package 'ntp'

service 'ntp' do
  service_name 'ntp'
  pattern 'ntpd'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/ntp.conf' do
  source    'ntp/ntp.conf.erb'
  owner     'ntp'
  group     'ntp'
  mode      '0644'
  notifies  :restart, 'service[ntp]'
end

################################################################################
# samba
package 'samba'

service 'samba' do
  service_name 'smbd'
  pattern 'smbd'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/samba/smb.conf' do
  source    'samba/smb.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[samba]'
end

################################################################################
# smart
package 'smartmontools'

service 'smart' do
  service_name 'smartd'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/smartd.conf' do
  source    'smart/smartd.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[smart]'
end

template '/etc/default/smartmontools' do
  source    'smart/smartmontools.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[smart]'
end

################################################################################
# snmp
package 'snmpd'

service 'snmp' do
  service_name 'snmpd'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/snmp/snmpd.conf' do
  source    'snmp/snmpd.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[snmp]'
end

template '/etc/default/snmpd' do
  source    'snmp/snmpd.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[snmp]'
end

template '/etc/snmp/disk_temp.zsh' do
  source    'snmp/disk_temp.zsh.erb'
  owner     'root'
  group     'root'
  mode      '0755'
end

template '/etc/snmp/hard_temp.zsh' do
  source    'snmp/hard_temp.zsh.erb'
  owner     'root'
  group     'root'
  mode      '0755'
end

################################################################################
# ssh
package 'openssh-client'
package 'openssh-server'

service 'ssh' do
  service_name 'ssh'
  pattern 'sshd'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/ssh/sshd_config' do
  source    'ssh/sshd_config.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[ssh]'
end

################################################################################
# sudo
package 'sudo'
template '/etc/sudoers' do
  source    'sudo/sudoers.erb'
  owner     'root'
  group     'root'
  mode      '0440'
end

################################################################################
# system
template '/etc/rc.local' do
  source    'system/rc.local.erb'
  owner     'root'
  group     'root'
  mode      '0755'
end

################################################################################
# sysctl
template '/etc/sysctl.conf' do
  source    'sysctl/sysctl.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :run, 'execute[sysctl]'
end

execute 'sysctl' do
  command   'sysctl -p'
  action    :nothing
end

################################################################################
# miscellaneous
package 'binutils'
package 'inotify-tools'
package 'daemontools'

package 'cifs-utils'

package 'postfix'
package 'mdadm'

package 'ruby'
