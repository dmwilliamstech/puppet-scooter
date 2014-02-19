# puppet-scooter

A Puppet module for deploying a [Scooter](https://github.com/airgap/scooter) application.


---

I happen to be using this with [Vagrant](http://vagrantup.com) to rapidly provision a basic CentOS server with a Scooter environment.

---

Requires an application container, I'm using Tomcat6

My manifest is super simple:

```
group { "puppet": ensure => "present", }

Exec { path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", }

class { "scooter":
  openstack_key_id => "some key",
  openstack_url => "hostname",
  puppet_hostname => "hostname",
  openstack_tenant_id => "2ba2d60c5e8d4d1b86549d988131fe48"
}

NOTE: there are several other variables you can provide to the scooter class in order to fine tune your installation.

```
