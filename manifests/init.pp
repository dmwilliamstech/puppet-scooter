class node_builder(
 $deploy_user="tomcat",
 $artifact_url="http://rizzo/nexus/service/local/artifact/maven/redirect?r=snapshots&g=org.codice.opendx&a=node-builder&v=1.0-SNAPSHOT&e=war",
 $deploy_path="/usr/share/tomcat6/webapps",
 
 $openstack_url = "https://localhost:5000/v2.0",
 $openstack_username = "username",
 $openstack_password = "password",
 $openstack_tenant_id  = "hash",
 $openstack_key_id = "id",
 $openstack_flavor_id = "small",
 
 $puppet_name = 'puppet',
 $puppet_hostname = 'localhost',
 $puppet_username = 'username',
 $puppet_private_key = '~/.ssh/id_rsa',
 $puppet_remote_path = '/etc/puppetlabs/puppet/manifests/nodes/',
 
 $smtp_hostname = 'hostname',
 $smtp_port = 465,
 $smtp_username = 'username',
 $smtp_password = 'password',
 $smtp_from = 'from@hostname',
 
 $imap_hostname = 'hostname',
 $imap_port = 993,
 $imap_username = 'username',
 $imap_password = 'password',
 $imap_folder = 'INBOX',
 
 $workspace_path = '/tmp/wc',
 
 $jenkins_url = "http://hostname/jenkins",
 $jenkins_user = "jenkins",
 $jenkins_password = "password",
 
 $jira_url = "http://hostname/jira",
 $jira_user = "jira",
 $jira_password = "password",
 $jira_project = "PRJ",
 $jira_issue_type = 1l,
 
 $db_url = "jdbc:postgresql://localhost:5432/nodebuilder",
 $db_username = "tomcat",
 $db_password = "t0mc4t",
 
 $mongo_host = "localhost",
 $mongo_port = 27017,
 $mongo_username = "mongo",
 $mongo_password = "mongo",
 $mongo_db_name = "nodebuilder",
 
 $ldap_manager_dn = 'cn=age,ou=users,dc=airgapit,dc=com',
 $ldap_manager_password = 'foobar99',
 $ldap_server = 'ldaps://ldap:636',
 $ldap_group_search_base = 'ou=groups,dc=airgapit,dc=com',
 $ldap_group_search_filter = "uniqueMember={0}",
 $ldap_search_base = "ou=users,dc=airgapit,dc=com",

  ) {

    service { "tomcat6":
           ensure => running,

    }    
    file { "config":
           path => "/etc/node-builder.conf",
           owner => "root",
           group   => 'root',
           mode    => '0644',
           content => template('node_builder/node-builder.conf.erb')
    } ->
    file { "ldap-config":
           path => "/etc/node-builder-ldap.groovy",
           owner => "root",
           group   => 'root',
           mode    => '0644',
           content => template('node_builder/node-builder-ldap.conf.erb')
    } ->
    file { "datasource-config":
           path => "/etc/node-builder-datasource.groovy",
           owner => "root",
           group   => 'root',
           mode    => '0644',
           content => template('node_builder/node-builder-datasource.conf.erb')
    } -> 
    exec { "new-version":
      command => "curl -o $deploy_path/node-builder-new-version.txt  \"$artifact_url\""
    } ->
    exec { "deploy node builder":
           unless   => "diff $deploy_path/node-builder-new-version.txt $deploy_path/node-builder-version.txt",
           notify   => Service['tomcat6'],
           command  =>  "curl  --location --referer \";auto\" -o /tmp/node-builder.war \"$artifact_url\"  ; mv -f /tmp/node-builder.war $deploy_path ; mv $deploy_path/node-builder-new-version.txt $deploy_path/node-builder-version.txt",
           user => "$deploy_user"
    }

 }
