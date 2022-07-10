#!/bin/bash
read -p "Enter IP address: " x_ip
read -p "Enter short hostname: " x_shortHostname
read -p "Enter domain: " x_domain
read -p "Enter other machine IP address: " x_otherIP
read -p "Enter other machine short hostname: " x_otherShortHostname
read -p "Enter other machine domain: " x_otherDomain
read -p "Enter db SID: " x_sid
read -p "Enter db product version (eq. 12.2.0): " x_dbProductVersion

x_fullHostname=${x_shortHostname}.${x_domain}
x_otherFullHostname=${x_otherShortHostname}.${x_otherDomain}



cat << EOF > /etc/sysconfig/network-scripts/ifcfg-enp0s3_new
$(sed '1q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '2q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '3q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '4q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '5q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '6q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '7q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '8q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '9q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '10q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '11q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '12q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '13q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
$(sed '14q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s3)
ONBOOT=yes
EOF
mv /etc/sysconfig/network-scripts/ifcfg-enp0s3 /etc/sysconfig/network-scripts/ifcfg-enp0s3_old
mv /etc/sysconfig/network-scripts/ifcfg-enp0s3_new /etc/sysconfig/network-scripts/ifcfg-enp0s3



cat << EOF > /etc/sysconfig/network-scripts/ifcfg-enp0s8_new
$(sed '1q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '2q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '3q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
BOOTPROTO=none
IPADDR=${x_ip}
PREFIX=24
$(sed '5q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '6q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '7q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '8q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '9q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '10q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '11q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '12q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '13q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
$(sed '14q;d' /etc/sysconfig/network-scripts/ifcfg-enp0s8)
ONBOOT=yes
AUTOCONNECT_PRIORITY=-999
EOF
mv /etc/sysconfig/network-scripts/ifcfg-enp0s8 /etc/sysconfig/network-scripts/ifcfg-enp0s8_old
mv /etc/sysconfig/network-scripts/ifcfg-enp0s8_new /etc/sysconfig/network-scripts/ifcfg-enp0s8



#ifdown enp0s3
#ifup enp0s3
#ifdown enp0s8
#ifup enp0s8



useradd oracle
groupadd oinstall
usermod -g oinstall oracle
sudo passwd oracle



cat << EOF > /etc/hostname
${x_fullHostname}
EOF



cat << EOF > /etc/hosts
127.0.0.1 ${x_shortHostname} ${x_fullHostname}
::1 ${x_shortHostname} ${x_fullHostname}
${x_otherIP} ${x_otherShortHostname} ${x_otherFullHostname}
EOF



cd /opt
mkdir oracle
mkdir orainstall
mkdir oraInventory
chown oracle:oinstall oracle
chown oracle:oinstall orainstall
chown oracle:oinstall oraInventory
chmod 700 oracle
chmod 750 orainstall
chmod 770 oraInventory



cd /var
mkdir databases
chown oracle:oinstall databases



cd /var/databases
mkdir oracle
chown oracle:oinstall oracle
chmod 755 oracle



cd /var/databases/oracle
mkdir fast_recovery_area
chown oracle:oinstall fast_recovery_area
chmod 755 fast_recovery_area
mkdir oradata
chown oracle:oinstall oradata
chmod 750 oradata



mkdir -p /opt/oracle/product/${x_dbProductVersion}/db_1
cd /opt/oracle
chown -R oracle:oinstall product
mkdir -p /opt/oracle/orainstall
cd /opt/oracle
chown -R oracle:oinstall orainstall



yum -y install bc binutils compat-libcap1 compat-libstdc++-33 glibc glibc-devel ksh libaio libaio-devel libX11 libXau libXi libXtst libXrender libXrender-devel libgcc libstdc++ libstdc++-devel libxcb make nfs-utils net-tools smartmontools sysstat unixODBC unixODBC-devel elfutils-libelf elfutils-libelf-devel htop
yum -y install libXp libXtst.x86_64 xclock smartmontools xdpyinfo xorg-x11-fonts-Type1 unzip
yum install -y gcc-c++
yum -y install epel-release
yum -y install htop



cat << EOF >> /etc/sysctl.conf
### for ORACLE 12gR2 ###
vm.swappiness = 1
vm.dirty_background_ratio = 3
vm.dirty_ratio = 80
vm.dirty_expire_centisecs = 500
vm.dirty_writeback_centisecs = 100
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
kernel.panic_on_oops = 1
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500
EOF



cat << EOF >> /home/oracle/.bash_profile
ORACLE_HOSTNAME=${x_fullHostname}; export ORACLE_HOSTNAME
ORACLE_UNQNAME=${x_sid}; export ORACLE_UNQNAME
ORACLE_BASE=/opt/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/${x_dbProductVersion}/db_1; export ORACLE_HOME
ORACLE_SID=${x_sid}; export ORACLE_SID
PATH=$ORACLE_HOME/bin:/usr/sbin:$HOME/bin:$PATH; export PATH
PATH=$ORACLE_HOME/OPatch:$PATH; export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
NLS_LANG=POLISH_POLAND.EE8ISO8859P2; export NLS_LANG
NLS_DATE_FORMAT="yyyy-mm-dd hh24:mi:ss"; export NLS_DATE_FORMAT
export DISPLAY=192.168.56.1:0.0
EOF



chown oracle:oinstall /home/oracle/.bash_profile
cat << EOF >> /etc/security/limits.conf
oracle soft nproc 16384
oracle hard nproc 16384
oracle soft nofile 20480
oracle hard nofile 65536
oracle soft stack 10240
oracle hard stack 32768
* soft memlock 134217728
* hard memlock 134217728
EOF



cd /home/oracle
mkdir scripts
mkdir logs



cd /home/oracle/scripts
cat << EOF >> setEnv.sh
# Oracle Settings
export TMP=/tmp
export TMPDIR=$TMP
export ORACLE_HOSTNAME=${x_fullHostname}
export ORACLE_UNQNAME=${x_sid}
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=$ORACLE_BASE/product/${x_dbProductVersion}/db_1
export ORACLE_SID=${x_sid}
export PATH=/usr/sbin:/usr/local/bin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
EOF



cd /home/oracle/scripts
cat << EOF >> start_all.sh
#!/bin/bash
. /home/oracle/scripts/setEnv.sh
export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES
dbstart $ORACLE_HOME
EOF



cd /home/oracle/scripts
cat << EOF >> stop_all.sh
#!/bin/bash
. /home/oracle/scripts/setEnv.sh
export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES
dbshut $ORACLE_HOME
EOF



cd /home/oracle/scripts
chown oracle:oinstall setEnv.sh
chown oracle:oinstall start_all.sh
chown oracle:oinstall stop_all.sh
chmod 744 setEnv.sh
chmod 744 start_all.sh
chmod 744 stop_all.sh
cd /home/oracle/
chown oracle:oinstall scripts
chown oracle:oinstall logs



cd /home/oracle
cat << EOF > listener.ora
# listener.ora Network Configuration File: /opt/oracle/product/${x_dbProductVersion}/db_1/network/admin/listener.ora
# Generated by Oracle configuration tools.

LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ${x_fullHostname})(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )


EOF



cd /home/oracle
cat << EOF > tnsnames.ora
# tnsnames.ora Network Configuration File: /opt/oracle/product/${x_dbProductVersion}/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

${x_sid} =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ${x_fullHostname})(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = ${x_sid})
      (SERVER = DEDICATED)
    )
  )


EOF



cd /home/oracle
cat << EOF > sqlnet.ora
# sqlnet.ora Network Configuration File: /opt/oracle/product/${x_dbProductVersion}/db_1/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)
SQLNET.ALLOWED_LOGON_VERSION_SERVER=8
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=8
DISABLE_OOB=on
#ASO Encryption
sqlnet.encryption_server=REQUIRED
sqlnet.encryption_client=REQUIRED
#ASO Checksum
sqlnet.crypto_checksum_server=REQUIRED
sqlnet.crypto_checksum_client=REQUIRED
EOF



cd /home/oracle
chown oracle:oinstall listener.ora
chown oracle:oinstall tnsnames.ora
chown oracle:oinstall sqlnet.ora



cd /lib/systemd/system/
cat << EOF > /lib/systemd/system/dbora.service
[Unit]
Description=The Oracle Database Service
After=syslog.target network.target
[Service]
# systemd ignores PAM limits, so set any necessary limits in the service.
# Not really a bug, but a feature.
# https://bugzilla.redhat.com/show_bug.cgi?id=754285
LimitMEMLOCK=infinity
LimitNOFILE=65535
#Type=simple
# idle: similar to simple, the actual execution of the service binary is delayed
# until all jobs are finished, which avoids mixing the status output with shell output of services.
RemainAfterExit=yes
User=oracle
Group=oinstall
ExecStart=/home/oracle/scripts/start_all.sh
ExecStop=/home/oracle/scripts/stop_all.sh
[Install]
WantedBy=multi-user.target
EOF



systemctl stop firewalld
systemctl disable firewalld



echo "Please to reboot your system now"
