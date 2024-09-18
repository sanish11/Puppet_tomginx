node default {
  # Ensure Chocolatey is installed
  class { 'chocolatey':
    choco_install_location => 'C:\ProgramData\chocolatey',
  }

  # Install JDK via Chocolatey
  package { 'jdk8':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Set JAVA_HOME environment variable using Puppet's environment resource
  environment { 'JAVA_HOME':
    value => 'C:\\Program Files\\Java\\jdk1.8.0_291',
  }

  # Install Git via Chocolatey
  package { 'git':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Install NVM (Node Version Manager)
  exec { 'install-nvm':
    command => 'Invoke-WebRequest -Uri https://raw.githubusercontent.com/coreybutler/nvm-windows/master/nvm-setup.zip -OutFile C:\nvm-setup.zip; Expand-Archive -Path C:\nvm-setup.zip -DestinationPath C:\nvm; C:\nvm\nvm-setup.exe /SILENT',
    creates => 'C:\Program Files\nodejs\nvm.exe',
    path    => 'C:\Windows\System32',
  }

  # Install Node.js version 14.17.3 using NVM
  exec { 'install-node':
    command => 'nvm install 14.17.3 && nvm use 14.17.3',
    path    => 'C:\Program Files\nvm',
    require => Package['nvm'],
  }

  # Install Angular CLI for versions 8, 16, and 20
  exec { 'install-angular-8':
    command => 'npm install -g @angular/cli@8',
    path    => 'C:\Program Files\nodejs',
    require => Exec['install-node'],
  }

  exec { 'install-angular-16':
    command => 'npm install -g @angular/cli@16',
    path    => 'C:\Program Files\nodejs',
    require => Exec['install-node'],
  }

  exec { 'install-angular-20':
    command => 'npm install -g @angular/cli@20',
    path    => 'C:\Program Files\nodejs',
    require => Exec['install-node'],
  }

  # Set NVM_HOME and NVM_SYMLINK using Puppet's environment resource
  environment { 'NVM_HOME':
    value => 'C:\\Program Files\\nvm',
  }

  environment { 'NVM_SYMLINK':
    value => 'C:\\Program Files\\nodejs',
  }

  # Add Node.js and NVM to PATH environment variable using Puppet's environment resource
  environment { 'PATH':
    value => 'C:\\Program Files\\nodejs;C:\\Program Files\\nvm',
    append => true, # Ensures the new paths are appended to the existing PATH
  }

  # Install Maven 3.9.6 using PowerShell for downloading and extraction
  exec { 'download-maven':
    command => 'powershell.exe -Command "Invoke-WebRequest -Uri https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip -OutFile C:\\apache-maven-3.9.6-bin.zip"',
    creates => 'C:\apache-maven-3.9.6-bin.zip',
    path    => 'C:\Windows\System32\WindowsPowerShell\v1.0',
  }

  exec { 'extract-maven':
    command => 'powershell.exe -Command "Expand-Archive -Path C:\\apache-maven-3.9.6-bin.zip -DestinationPath C:\\Program Files"',
    creates => 'C:\Program Files\apache-maven-3.9.6',
    path    => 'C:\Windows\System32\WindowsPowerShell\v1.0',
    require => Exec['download-maven'],
  }

  # Set MAVEN_HOME environment variable using Puppet's environment resource
  environment { 'MAVEN_HOME':
    value => 'C:\\Program Files\\apache-maven-3.9.6',
  }

  # Add Maven to PATH environment variable using Puppet's environment resource
  environment { 'PATH':
    value => 'C:\\Program Files\\apache-maven-3.9.6\\bin',
    append => true, # Ensures Maven bin path is appended to the existing PATH
  }
}
