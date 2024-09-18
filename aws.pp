# Define a node block for your AWS instance
node 'aws_instance' {
  
  # Update package repositories and install Git
  package { 'git':
    ensure => installed,
  }

  # Install required packages for Docker
  package { ['apt-transport-https', 'ca-certificates', 'curl', 'software-properties-common']:
    ensure => installed,
  }

  # Add Docker GPG key
  apt_key { 'docker_gpg_key':
    ensure  => present,
    source  => 'https://download.docker.com/linux/ubuntu/gpg',
  }

  # Add Docker repository
  apt_repository { 'docker_repo':
    ensure    => present,
    location  => 'https://download.docker.com/linux/ubuntu',
    repos     => 'focal',
    release   => 'stable',
    include_src => false,
  }

  # Install Docker
  package { 'docker-ce':
    ensure => installed,
    require => [Apt_key['docker_gpg_key'], Apt_repository['docker_repo']],
  }

  # Start Docker service
  service { 'docker':
    ensure => running,
    enable => true,
    require => Package['docker-ce'],
  }

  # Add ec2-user to Docker group
  group { 'docker':
    ensure => present,
  }

  user { 'ec2-user':
    ensure  => present,
    groups  => ['docker'],
    require => Group['docker'],
  }
}
