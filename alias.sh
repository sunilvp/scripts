#!/bin/bash
myenv ( )
{
	export PYTHONPATH=$PYTHONPATH:'/opt/vsd/sysmon':'/opt/vsd/redundancy/':'/opt/vsd/password/'
	if [ -r /opt/vsd/install/vsd_password.ini ] \
	        && [ -x /opt/vsd/password/passwordParser.py ] \
	        && python /opt/vsd/password/passwordParser.py -v >> /opt/vsd/logs/install.log 2>&1 ; then
	    :
	   eval $(python /opt/vsd/password/passwordParser.py 2>> /opt/vsd/logs/install.log)
	else
	   echo "ERROR: vsd-deploy, Failed to use the password file please check if file and permission exists"
	fi
}

function getPid() {
	if [[ $1 == "amq" || $1 == "a" || $1 == "activemq" ]]; then
		echo "Activemq Pid:"
		printPid "activemq.jar start"
		echo "Pid Details:"
		printPidDetails "activemq.jar start"
    elif [[ $1 == "jboss" || $1 == "j" ]]; then
    	echo "Jboss Pid:"
		printPid "jboss.server.base.dir=/opt/vsd/jboss/standalone"
		echo "Pid Details:"
		printPidDetails "jboss.server.base.dir=/opt/vsd/jboss/standalone"
	elif [[ $1 == "ej" || $1 == "ejabberd" || $1 == "e" ]]; then
		echo "Ejabberd Pid:"
		printPid "/opt/ejabberd/bin/beam.smp"
		echo "Pid Details:"
		printPidDetails "/opt/ejabberd/bin/beam.smp"
	elif [[ $1 == "tca" ]]; then
		echo "TCA Pid:"
		printPid "AREServer"
		echo "Pid Details:"
		printPidDetails "AREServer"
	elif [[ $1 == "stats" ]]; then
		echo "Stats Pid:"
		printPid "StatsCollectorServer"
		echo "Pid Details:"
		printPidDetails	"StatsCollectorServer"
	elif [[ $1 == "key" || $1 == "keyserver" || $1 == "k" ]]; then
		echo "Keyserver Pid:"
		printPid "KeyServerController"
		echo "Pid Details:"
		printPidDetails "KeyServerController"
	elif [[ $1 == "infi" || $1 == "i" ]]; then
		echo "Infinispan Pid:"
		printPid "infinispan/modules"
		echo "Pid Details:"
		printPidDetails	"infinispan/modules"
	elif [[ $1 == "med" || $1 == "mediator" || $1 == "m" ]]; then
		echo "Mediator Pid:"
		printPid "MediationController"
		echo "Pid Details:"
		printPidDetails	"MediationController"
	elif [[ $1 == "proxysql" || $1 == "p" ]]; then
		echo "Proxysql Pid:"
		printPidParentPidName "/usr/bin/proxysql -c /etc/proxysql.cnf -D /var/lib/proxysql"
		echo "Pid Details:"
		printPidDetails "/usr/bin/proxysql -c /etc/proxysql.cnf -D /var/lib/proxysql"
	elif [[ $1 == "mysql" || $1 == "y" ]] \
		&& [[ -f /var/run/mysql/mysql.pid ]]; then
		echo "Mysql Pid:"
		cat /var/run/mysql/mysql.pid
		echo "Pid Details:"
		ps -eo pid,lstart,cmd | grep `cat /var/run/mysql/mysql.pid` | grep -v grep
	elif [[ $1 == "zoo" || $1 == "z" ]] \
		&& [[ -f /var/run/zookeeper/zookeeper-server.pid ]]; then
		echo "zookeeper Pid:"
		cat /var/run/zookeeper/zookeeper-server.pid
		echo "Pid Details:"
		ps -eo pid,lstart,cmd | grep `cat /var/run/zookeeper/zookeeper-server.pid` | grep -v grep
	elif [[ $1 == "logstash" || $1 == "l" ]]; then
		echo "Logstash Pid:"
		printPid "org.logstash.Logstash --path.settings /opt/vsd/logstash/config"
		echo "Pid Details:"
		printPidDetails	"org.logstash.Logstash --path.settings /opt/vsd/logstash/config"
 	fi
}

function printPid() {
	ps -aef | grep "$1" | grep -v grep | awk '{print "\t" $2}'
}

function printPidDetails() {
	ps -eo pid,lstart,cmd | grep "$1" | grep -v grep
}

function printPidParentPidName() {
	ps -aef | grep "$1" | grep -v grep | awk '{print "\t" $2 "\t" $3}'
}

#alias for logs
alias lvs='clear; tail -1000f /opt/vsd/jboss/standalone/log/server.log'
alias lvv='clear; tail -1000f /opt/vsd/jboss/standalone/log/vsdserver.log'
alias lvx='clear; tail -1000f /opt/vsd/jboss/standalone/log/xmpp-conn.log'
alias lvw='clear; tail -1000f /opt/vsd/jboss/standalone/log/web.access/access.log'
alias lvz='clear; tail -1000f /opt/vsd/jboss/standalone/log/zfb.log'
alias lvk='clear; tail -1000f /opt/vsd/logs/keyserver/keyserver.log'
alias lvr='clear ; tail -1000f /opt/vsd/jboss/standalone/log/restclient.log'
alias lvm='clear; tail -1000f /opt/vsd/mediator/cna-mediator.log'
alias lmonit='clear; tail -1000f /var/log/monit.log'
alias lmysql='clear; tail -1000f /var/log/mysql/mysqld.log'
alias linstall='clear; tail -1000f /opt/vsd/logs/install.log'
alias ldecouple='clear; tail -1000f /opt/vsd/logs/patch.log'
alias lve='clear; tail -1000f /opt/ejabberd/logs/ejabberd.log'
alias linstall='clear ; tail -1000f /opt/vsd/logs/install.log'
alias lvxmppppush='clear;tail -10000f | grep -v com.alu.cna.cloudmgmt.common.core.xmpp.debugger.XmppClientCustomDebugger  /opt/vsd/logs/install.log | egrep -v "^$"'

#cd commands
alias cjboss='cd /opt/vsd/jboss/standalone'
alias cjbossd='cd /opt/vsd/jboss/standalone/deployments'
alias cjbossl='cd /opt/vsd/jboss/standalone/log'
alias cmediator='cd /opt/vsd/mediator'
alias cejabberd='cd /opt/ejabberd'
alias cproxysql='cd /var/lib/proxysql'
alias cymysql='cd /var/lib/mysql'
alias ckeyserver='cd /opt/vsd/keyserver'
alias cinstalllogs='cd /opt/vsd/logs'

#cli's
alias jcli='/opt/vsd/jboss/bin/jboss-cli.sh'
alias zcli='/usr/lib/zookeeper/bin/zkCli.sh'

#monit stop start restart
alias mssj='monit stop jboss'
alias msj='monit start jboss'
alias mssa='monit stop activemq'
alias msa='monit start activemq'
alias mrj='monit restart jboss'
alias mssm='monit stop mediator'
alias msm='monit start mediator'
alias mrm='monit restart mediator'
alias mssc='monit stop -g vsd-core'
alias msc='monit start -g vsd-core'
alias mssco='monit stop -g vsd-common'
alias msco='monit start -g vsd-common'
#monit check
alias mcj='/opt/vsd/sysmon/jbossStatus.py'
alias mcm='/opt/vsd/sysmon/mediatorStatus.py'
alias mcp='/opt/vsd/sysmon/proxysqlStatus.sh'
alias mcy='/opt/vsd/sysmon/perconaStatus.py'
alias mce='echo "EjabberdStatus: ";/opt/vsd/sysmon/ejabberdStatus.py'
alias mcas='/opt/vsd/sysmon/activemqStatus.py'
alias mca='/opt/vsd/sysmon/activemqStatus.py -c'
alias mcn='/opt/vsd/sysmon/ntpStatus.sh'
alias mcej='echo "EjbcaStatus:"; /opt/vsd/sysmon/ejbca-status.py'
alias mrntp='date; service ntpd stop ; sleep 1 ; service ntpd start ; date; watch ntpstat'
alias mck='/opt/vsd/sysmon/monit/keyserver-status.sh'
alias mci='/opt/vsd/sysmon/infinispanStatus.sh'
alias mcic='/opt/vsd/sysmon/infinispanStatus.sh -c'
alias mcz='/opt/vsd/sysmon/monit/datanode-zookeeper-server-status.sh'
alias mczc='/opt/vsd/sysmon/monit/datanode-zookeeper-cluster-status.sh'
alias mcl='/opt/vsd/sysmon/logstash-status.py'

#my commands to perform default operatations
alias cmysql='echo "check Mysql :"; mysql -e "select 1"'
alias vpass='cat /opt/vsd/install/vsd_password.ini'
alias vmonit='monit summary'
alias vlsof='lsof -i -P | grep $1'
alias vnetstat='netstat -peanut | grep $1'
alias viptables='iptables -nL | grep $1'
alias vstandbymode='echo "StandbyMode:";cat /opt/vsd/install/myenv.sh | grep "ENV_VSD_STANDBY"'
alias vmonitdir='cat /etc/monitrc | grep -v "^#" | grep include'
alias vproperties='grep -vE "^#|^[[:space:]]*$" $1'
alias vmonitrc='vproperties /etc/monitrc'

#proxysql check commands
alias psql='function _proxysql(){ myenv ;mysql -u admin -p$ENV_VSD_PROXYSQLPWD -h 127.0.0.1 -P 6032 -e "$1"; }; _proxysql'
alias pmysql='function _proxyMysql(){ myenv ;mysql -u cnauser -p$ENV_VSD_CNAPWD -P 6033 -e "$1"; }; _proxyMysql'
alias pser='myenv ;mysql -u admin -p$ENV_VSD_PROXYSQLPWD -h 127.0.0.1 -P 6032 -e "select * from runtime_mysql_servers order by hostgroup_id"'
alias psche='myenv ;mysql -u admin -p$ENV_VSD_PROXYSQLPWD -h 127.0.0.1 -P 6032 -e "select * from scheduler\G"'
alias pusers='myenv ;mysql -u admin -p$ENV_VSD_PROXYSQLPWD -h 127.0.0.1 -P 6032 -e "select * from runtime_mysql_users"'
alias prules='myenv ;mysql -u admin -p$ENV_VSD_PROXYSQLPWD -h 127.0.0.1 -P 6032 -e "select * from runtime_mysql_query_rules"'
alias pconpool='myenv ;mysql -u admin -p$ENV_VSD_PROXYSQLPWD -h 127.0.0.1 -P 6032 -e "select * from stats_mysql_connection_pool"'
alias lproxy="clear; tail -1000f /var/lib/proxysql/proxysql.log"
alias vphost="cat /var/lib/proxysql/host_priority.conf"
alias vpadmin="cat /etc/proxysql-admin.cnf"
alias plite="sqlite3 /var/lib/proxysql/proxysql.db"
alias yboot="/opt/vsd/sysmon/bootPercona.py --force"
alias ywstatus="mysql --user=root --password="$ENV_MYSQL_ROOT_PWD" -e \"select * from information_schema.GLOBAL_STATUS where VARIABLE_NAME LIKE 'wsrep_ready' OR VARIABLE_NAME LIKE 'wsrep_incoming_addresses' OR VARIABLE_NAME LIKE 'wsrep_cluster_size' OR VARIABLE_NAME LIKE 'wsrep_local_state' OR VARIABLE_NAME LIKE 'wsrep_local_state_comment'\""
alias enableSlowLog="mysql --user=root --password="$ENV_MYSQL_ROOT_PWD" -e \"SET GLOBAL general_log = 'ON' \""
alias yswstatus="mysql --user=root --password="$ENV_MYSQL_ROOT_PWD" -e \"show slave status\G\" | grep -E \"Seconds_Behind_Master|Slave_IO_State|Slave_IO_Running|Slave_SQL_Running:\""

alias showstatus='/opt/vsd/sysmon/showStatus.py'


#ejabberd
alias estatus='/opt/ejabberd/bin/ejabberdctl status'
alias eusers='/opt/ejabberd/bin/ejabberdctl connected_users'
alias elistc='/opt/ejabberd/bin/ejabberdctl list_cluster'
alias elistp='/opt/ejabberd/bin/ejabberdctl list_p1db'
alias eslog='/opt/ejabberd/bin/ejabberdctl set_loglevel 5'
alias esslog='/opt/ejabberd/bin/ejabberdctl set_loglevel 3'
alias etopiccout='/opt/ejabberd/bin/ejabberdctl p1db_records_number | grep pubsub_node'
alias ejstatus='/opt/vsd/bin/ejmode status'
alias ejallow='/opt/vsd/bin/ejmode allow'
alias ejreq='/opt/vsd/bin/ejmode require'

#ejbca
alias ejcas='/opt/vsd/ejbca/bin/ejbca.sh ca listcas'
alias ejend='/opt/vsd/ejbca/bin/ejbca.sh ra listendentities -S 00'
alias ejexp='mysql --user=root --password="$ENV_MYSQL_ROOT_PWD" ejbca -e "SELECT u.username, c.subjectDN, from_unixtime(floor(expireDate/1000)) expiryDate FROM UserData u, CertificateData c WHERE c.username = u.username AND revocationDate = -1 ORDER BY expiryDate ASC;"'

#xmpp-tool
alias xnodes='/opt/vsd/tools/xmpp_client.py nodes'
alias xping='/opt/vsd/tools/xmpp_client.py -u cna -p cnauser -t ping subscriptions'
alias xcnajid='/opt/vsd/tools/xmpp_client.py -t cna_discover_jid nodes'

# logstash
alias lvl1='clear ; tail -1000f /var/log/logstash/logstash-plain.log'
alias loinstall1='cd /usr/share/logstash;  /usr/share/logstash/bin/logstash-plugin install /home/sunil/logstash-filter-nuage_filter_enrichment-1.0.0.gem'
alias loremove1='cd /usr/share/logstash;  /usr/share/logstash/bin/logstash-plugin remove logstash-filter-nuage_filter_enrichment'
alias locheckplugin1='cd /usr/share/logstash; /usr/share/logstash/bin/logstash-plugin list| grep nuage'

#logstash_new
alias lvl='clear ; tail -1000f /opt/vsd/logstash/logs/logstash-plain.log'
alias loinstall='cd /opt/vsd/logstash;  /opt/vsd/logstash/bin/logstash-plugin install /home/sunil/logstash-filter-nuage_filter_enrichment-1.0.0.gem'
alias loremove='cd /opt/vsd/logstash;  /opt/vsd/logstash/bin/logstash-plugin remove logstash-filter-nuage_filter_enrichment'
alias locheckplugin='cd /opt/vsd/logstash; /opt/vsd/logstash/bin/logstash-plugin list --verbose| grep nuage'
alias vlomonit='cat /opt/vsd/logstash/lsmon.monit'
alias lvls='clear ; tail -1000f /opt/vsd/logstash/logs/syslog_collector.log'
alias clogstash='cd /opt/vsd/logstash'

alias iopen='function _iptables(){ iptables -I INPUT -p tcp -m tcp --dport $1 -j ACCEPT ;}; _iptables'
alias ip='ifconfig'

alias pid='getPid $1'

alias gaccessfailure='grep -v "OPTIONS" /opt/vsd/jboss/standalone/log/web.access/access.log* |grep -v "/me " | grep -v "events" | grep -Ev "HTTP/1.1 201|HTTP/1.1 204|HTTP/1.1 200|HTTP/1.0 200"'

# virsh alias
alias virc='virsh console'
alias virde='virsh define'
alias virx='virsh dumpxml'
alias vire='virsh edit'
alias vird='virsh destroy'
alias virs='virsh start'
alias virl='virsh list'
alias viru='virsh undefine'


# DEBUG mode
alias djboss='sed -i "s/^DEBUG_MODE=false/DEBUG_MODE=true/" /opt/vsd/jboss/bin/standalone.sh'
alias dmed='sed -i "s/^DEBUG_MODE=false/DEBUG_MODE=true/" /etc/init.d/mediator.sh'
alias dkey='sed -i "s/^DEBUG_MODE=false/DEBUG_MODE=true/" /opt/vsd/keyserver/bin/keyserver.sh'
alias dall='djboss ; dmed; dkey'
alias ijboss='iopen 8787'
alias imem='iopen 5005'
alias ikey='iopen 5006'
alias iall='ijboss; imem; ikey'
alias dport='iall; dall'

#log debug enable le log enable
alias lemed='/opt/vsd/mediator/runMediatorLogLevel.bash -l DEBUG'
alias lexmpp='/opt/vsd/bin/debug-jboss xmpp  DEBUG'
alias levsd='/opt/vsd/bin/debug-jboss vsd DEBUG'
alias leall='lemed; lexmpp; levsd'
