package { 'python':
    ensure  => present
}

group { 'housekeeping':
    ensure => present,
    name => 'housekeeping'
}

user { 'housekeeping':
    ensure     => present,
    name       => 'housekeeping',
    groups     => ['housekeeping'],
    shell      => '/usr/sbin/nologin',
    managehome => false,
    system     => true,
    require    => Group['housekeeping']
}

file { '/opt/housekeeping/bin/install.sh':
    ensure  => file,
    owner   => 'housekeeping',
    group   => 'housekeeping',
    mode    => '+x',
    require => [User['housekeeping'], Group['housekeeping']]
}

cron { 'install-housekeeping':
    ensure  => present,
    command => '/opt/housekeeping/bin/install.sh',
    user    => 'root',
    minute  => 0,
    require => File['/opt/housekeeping/bin/install.sh']
}

file { '/opt/housekeeping/bin/logrotate.py':
    ensure  => file,
    owner   => 'housekeeping',
    group   => 'housekeeping',
    mode    => '+x',
    require => [User['housekeeping'], Group['housekeeping']]
}

cron { 'run-housekeeping':
    ensure  => present,
    command => '/opt/housekeeping/bin/logrotate.py /app/logs',
    user    => 'housekeeping',
    hour    => 1,
    require => [Package['python'], File['/opt/housekeeping/bin/logrotate.py'], File['/app/logs']]
}

file { ['/app', '/app/logs']:
    ensure  => directory,
    owner   => 'app',
    group   => 'housekeeping',
    mode    => '0664',
    require => [User['app'], Group['housekeeping']]
}

user { 'app':
    ensure     => present,
    name       => 'app',
    groups     => ['housekeeping'],
    shell      => '/usr/sbin/nologin',
    managehome => false,
    system     => true,
    require    => Group['housekeeping']
}
