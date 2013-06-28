class node_builder($deploy_user="tomcat",
 $artifact_url="http://artifacts.codice.org/content/repositories/snapshots/org/codice/opendx/node-builder/1.0-SNAPSHOT/node-builder-1.0-20130628.170856-4.war",
 $deploy_path="/usr/share/tomcat6/webapps",
 $openstack_hostname = "localhost",
 $openstack_username = "admin",
 $openstack_password = "stack",
 $openstack_tenant_id  = "",
 $openstack_key_id = "",
 $openstack_flavor_id = "1",
 $master_name = 'nodenabox',
 $master_hostname = 'localhost',
 $master_username = 'stack',
 $master_private_key = '~/.ssh/id_rsa',
 $master_remote_path = '/etc/puppetlabs/puppet/manifests/nodes/',
 ) {

  file { "config":
    path => "/etc/node-builder.conf",
    owner => "root",
    group   => 'root',
    mode    => '0644',
    content => template('node_builder/config.erb')
  } ->
  exec { "deploy node builder":
    command  =>  "curl -o /tmp/node-builder.war $artifact_url  ; mv /tmp/node-builder.war $deploy_path",
    creates  =>  "$deploy_path/node-builder.war",
    user => "$deploy_user"
  } 
  
}
