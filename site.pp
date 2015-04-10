
node 'agent.openstacklocal' {
    include django-app
    include mongodb
    include apache
    
    file { '/srv/app':
        ensure => directory,
    }

    class { 'apache::mod::wsgi':
	wsgi_socket_prefix => "\${APACHE_RUN_DIR}WSGI",
        #wsgi_python_home   => '/srv/app/MyTestProject/env/lib/python2.7/',
        require => file["/srv/app"],
	wsgi_python_path => '/srv/app/MyTestProject/MyTestProject:/srv/app/MyTestProject/env/lib/python2.7/site-packages',
    }

    apache::vhost { "wsgi_app":
	servername => 'ashlarsoftware.is-a-techie.com',
	port => '80',
	docroot => '/srv/app',
	wsgi_script_aliases => { '/' => '/srv/app/MyTestProject/MyTestProject.wsgi' },
        #wsgi_daemon_process         => 'MyTestProject',
        #wsgi_process_group => 'MyTestProject',
        priority => '000',
	error_log_file => 'ashlarsoftware_error.log',
	access_log_file => 'ashlarsoftware_access.log',
	default_vhost => true,
    }

    class { 'apt':
	always_apt_update    => false,
	apt_update_frequency => undef,
	disable_keys         => undef,
	proxy_host           => false,
	proxy_port           => '8080',
	purge_sources_list   => false,
	purge_sources_list_d => false,
	purge_preferences_d  => false,
	update_timeout       => undef,
	fancy_progress       => undef
    }
}
