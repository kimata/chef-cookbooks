# Cookbook Name:: router
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
# bind
package 'bind9'

directory '/var/log/named' do
  owner     'bind'
  group     'bind'
  mode      '0755'
  action    :create
end

service 'bind' do
  service_name 'bind9'
  pattern 'named'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/bind/named.conf' do
  source    'bind/named.conf.erb'
  owner     'bind'
  group     'bind'
  mode      '0644'
  notifies  :restart, 'service[bind]'
end

template '/etc/bind/named.conf.options' do
  source    'bind/named.conf.options.erb'
  owner     'bind'
  group     'bind'
  mode      '0644'
  notifies  :restart, 'service[bind]'
end

template '/etc/bind/named.conf.zones' do
  source    'bind/named.conf.zones.erb'
  owner     'bind'
  group     'bind'
  mode      '0644'
  notifies  :restart, 'service[bind]'
end

template '/etc/bind/db.root' do
  source    'bind/db.root.erb'
  owner     'bind'
  group     'bind'
  mode      '0644'
  notifies  :restart, 'service[bind]'
end

template '/etc/bind/db.local' do
  source    'bind/db.local.erb'
  owner     'bind'
  group     'bind'
  mode      '0644'
  notifies  :restart, 'service[bind]'
end

template '/etc/bind/db.127' do
  source    'bind/db.127.erb'
  owner     'bind'
  group     'bind'
  mode      '0644'
  notifies  :restart, 'service[bind]'
end

template '/etc/bind/db.green-rabbit.net-internal' do
  source 'bind/db.green-rabbit.net-internal.erb'
  owner     'bind'
  group     'bind'
  mode      '0644'
  notifies  :restart, 'service[bind]'
end

template '/etc/bind/db.2.168.192' do
  source    'bind/db.2.168.192.erb'
  owner     'bind'
  group     'bind'
  mode      '0644'
  notifies  :restart, 'service[bind]'
end

link '/var/cache/bind/db.2.168.192' do
  to        '/etc/bind/db.2.168.192'
  not_if    'test -e /var/cache/bind/db.2.168.192'
  notifies  :restart, 'service[bind]'
end

link '/var/cache/bind/db.green-rabbit.net-internal' do
  to        '/etc/bind/db.2.168.192'
  not_if    'test -e /var/cache/bind/db.green-rabbit.net-internal'
  notifies  :restart, 'service[bind]'
end

################################################################################
# dhcp
package 'isc-dhcp-server'

service 'dhcp' do
  service_name 'isc-dhcp-server'
  pattern 'dhcpd'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/dhcp/dhcpd.conf' do
  source    'dhcp/dhcpd.conf.erb'
  owner     'dhcpd'
  group     'dhcpd'
  mode      '0644'
  notifies  :restart, 'service[dhcp]'
end

template '/etc/dhcp/dhclient.conf' do
  source    'dhcp/dhclient.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
end

template '/etc/default/isc-dhcp-server' do
  source    'dhcp/isc-dhcp-server.erb'
  owner     'root'
  group     'root'
  mode      '0644'
end

################################################################################
# dovecot
package 'dovecot-imapd'

service 'dovecot' do
  service_name 'dovecot'
  pattern 'dovecot'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/dovecot/dovecot.conf' do
  source    'dovecot/dovecot.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[dovecot]'
end

################################################################################
# hdparm
package 'hdparm'
package 'sdparm'

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

################################################################################
# iptables
package 'iptables'

directory '/etc/iptables' do
  owner     'root'
  group     'root'
  mode      '0755'
  action    :create
end

template '/etc/iptables/rules.sh' do
  source    'iptables/rules.sh.erb'
  owner     'root'
  group     'root'
  mode      '0755'
  notifies  :run, 'execute[iptables]'
end

template '/etc/iptables/activate' do
  source    'iptables/activate.erb'
  owner     'root'
  group     'root'
  mode      '0755'
end

template '/etc/iptables/inactivate' do
  source    'iptables/inactivate.erb'
  owner     'root'
  group     'root'
  mode      '0755'
end

execute 'iptables' do
  command   '/etc/iptables/inactivate'
#  command   '/etc/iptables/activate'
  action    :nothing
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
package 'lvm2'

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
directory '/var/log/ntpstats' do
  owner     'ntp'
  group     'ntp'
  mode      '0755'
  action    :create
end

################################################################################
# postfix
package 'postfix'
package 'libsasl2-modules'
package 'sasl2-bin'

service 'postfix' do
  service_name 'postfix'
  pattern 'postfix'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

service 'saslauth' do
  service_name 'saslauthd'
  pattern 'saslauthd'
  supports value_for_platform(
    'ubuntu' => {
      'default' => [ :restart, :reload, :status ]
    },
  )
  action [ :enable, :start ]
end

template '/etc/postfix/main.cf' do
  source    'postfix/main.cf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[postfix]'
end

template '/etc/postfix/smtpd.conf' do
  source    'postfix/smtpd.conf.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[postfix]'
end

template '/etc/default/saslauthd' do
  source    'postfix/saslauthd.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[saslauth]'
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
# smartmontools
package 'smartmontools'

service 'smartmontools' do
  service_name 'smartmontools'
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
  notifies  :restart, 'service[smartmontools]'
end

template '/etc/default/smartmontools' do
  source    'smart/smartmontools.erb'
  owner     'root'
  group     'root'
  mode      '0644'
  notifies  :restart, 'service[smartmontools]'
end

################################################################################
# snmp
package 'snmpd'
package 'snmp-mibs-downloader'

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

template '/etc/snmp/ups_load.zsh' do
  source    'snmp/ups_load.zsh.erb'
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
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 13.10
      provider Chef::Provider::Service::Upstart
    end
  end
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
# sysctl
execute 'sysctl' do
  command   'sysctl -p'
  action    :nothing
end

template '/etc/sysctl.conf' do
  source    'sysctl/sysctl.conf.erb'
  owner     'root'
  group     'root'
  mode      '0440'
  notifies  :run, 'execute[sysctl]'
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
# ulog
# package 'ulogd'

# service 'ulog' do
#   service_name 'ulogd'
#   supports value_for_platform(
#     'ubuntu' => {
#       'default' => [ :restart, :reload, :status ]
#     },
#   )
#   action :nothing
# end

# template '/etc/ulogd.conf' do
#   source    'ulog/ulogd.conf.erb'
#   owner     'root'
#   group     'root'
#   mode      '0644'
#   notifies  :restart, 'service[ulog]'
# end

################################################################################
# miscellaneous
package 'binutils'
package 'inotify-tools'
package 'daemontools'

package 'apache2'

package 'ruby'
package 'mdadm'
package 'cifs-utils'



package 'dstat'

#apt-get install spamassassin spamc
