# manifest.pp
node default {
  # Ensure Chocolatey is installed
  class { 'chocolatey':
    choco_install_location => 'C:\ProgramData\chocolatey',
  }

  # Install JDK
  package { 'jdk8':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Set JAVA_HOME environment variable
  exec { 'set-java-home':
    command => 'setx JAVA_HOME "C:\\Program Files\\Java\\jdk1.8.0_291"',
    unless  => 'reg query "HKCU\\Environment" /v JAVA_HOME',
    path    => 'C:\Windows\System32',
  }

  # Install Git
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

  # Install Node.js using NVM
  exec { 'install-node':
    command => 'nvm install 14.17.3 && nvm use 14.17.3',
    path    => 'C:\Program Files\nodejs',
    require => Exec['install-nvm'],
  }

  # Install Angular CLI versions
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

  # Set NVM_DIR environment variable
  exec { 'set-nvm-dir':
    command => 'setx NVM_HOME "C:\\Program Files\\nodejs"',
    unless  => 'reg query "HKCU\\Environment" /v NVM_HOME',
    path    => 'C:\Windows\System32',
  }

  # Set NVM_SYMLINK environment variable
  exec { 'set-nvm-symlink':
    command => 'setx NVM_SYMLINK "C:\\Program Files\\nodejs"',
    unless  => 'reg query "HKCU\\Environment" /v NVM_SYMLINK',
    path    => 'C:\Windows\System32',
  }

  # Set PATH environment variable for Node.js and NVM
  exec { 'set-path':
    command => 'setx PATH "%PATH%;C:\\Program Files\\nodejs;C:\\Program Files\\nodejs\\nvm"',
    unless  => 'reg query "HKCU\\Environment" /v PATH | findstr /C:"C:\\Program Files\\nodejs"',
    path    => 'C:\Windows\System32',
  }

  # Install Maven 3.9.6
  exec { 'download-maven':
    command => 'Invoke-WebRequest -Uri https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip -OutFile C:\apache-maven-3.9.6-bin.zip',
    creates => 'C:\apache-maven-3.9.6-bin.zip',
    path    => 'C:\Windows\System32',
  }

  exec { 'extract-maven':
    command => 'Expand-Archive -Path C:\apache-maven-3.9.6-bin.zip -DestinationPath C:\Program Files',
    creates => 'C:\Program Files\apache-maven-3.9.6',
    path    => 'C:\Windows\System32',
    require => Exec['download-maven'],
  }

  # Set MAVEN_HOME environment variable
  exec { 'set-maven-home':
    command => 'setx MAVEN_HOME "C:\\Program Files\\apache-maven-3.9.6"',
    unless  => 'reg query "HKCU\\Environment" /v MAVEN_HOME',
    path    => 'C:\Windows\System32',
    require => Exec['extract-maven'],
  }

  # Add Maven to PATH environment variable
  exec { 'set-maven-path':
    command => 'setx PATH "%PATH%;C:\\Program Files\\apache-maven-3.9.6\\bin"',
    unless  => 'reg query "HKCU\\Environment" /v PATH | findstr /C:"C:\\Program Files\\apache-maven-3.9.6\\bin"',
    path    => 'C:\Windows\System32',
    require => Exec['set-maven-home'],
  }
}
