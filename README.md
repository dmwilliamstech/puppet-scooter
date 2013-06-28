# puppet-node_builder

A Puppet module for deploying a basic/raw DDF node.


---

I happen to be using this with [Vagrant](http://vagrantup.com) to rapidly provision a basic CentOS server with a NodeBuilder environment.

---

Requires an application container, I'm using Tomcat6

My manifest is super simple:

```
group { "puppet": ensure => "present", }

Exec { path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", }

package { "tomcat6":
    ensure => "installed"
} ->
service { "tomcat6":
  ensure => "running",
} ->
class { "node_builder":
  openstack_key_id => "opendx_demo",
  openstack_hostname => "107.2.16.122",
  master_hostname => "107.2.16.122",
  openstack_tenant_id => "2ba2d60c5e8d4d1b86549d988131fe48"
}

NOTE: there are several other variables you can provide to the node_builder class in order to fine tune your installation.

```