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

  # Set JAVA_HOME environment variable
  windows_env { 'JAVA_HOME':
    ensure    => present,
    value     => 'C:\Program Files\Java\jdk1.8.0_291',
    mergemode => 'clobber',
  }

  # Install Git via Chocolatey
  package { 'git':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Install NVM (Node Version Manager)
  exec { 'install-nvm':
    command => 'Invoke-WebRequest -Uri https://raw.githubusercontent.com/coreybutler/nvm-windows/master/nvm-setup.zip -OutFile C:\nvm-setup.zip; Expand-Archive -Path C:\nvm-setup.zip -DestinationPath C:\nvm; C:\nvm\nvm-setup.exe /SILENT',
    creates => 'C:\Program Files\nvm\nvm.exe',
    provider => 'powershell',
  }

  # Install Node.js version 14.17.3 using NVM
  exec { 'install-node':
    command => 'C:\Program Files\nvm\nvm.exe install 14.17.3 && C:\Program Files\nvm\nvm.exe use 14.17.3',
    unless  => 'C:\Program Files\nvm\nvm.exe list | Select-String -Pattern "14.17.3"',
    provider => 'powershell',
    require => Exec['install-nvm'],
  }

  # Install Angular CLI for versions 8, 16, and 20
  exec { 'install-angular-8':
    command => 'npm install -g @angular/cli@8',
    provider => 'powershell',
    require => Exec['install-node'],
  }
  exec { 'install-angular-16':
    command => 'npm install -g @angular/cli@16',
    provider => 'powershell',
    require => Exec['install-node'],
  }
  exec { 'install-angular-20':
    command => 'npm install -g @angular/cli@20',
    provider => 'powershell',
    require => Exec['install-node'],
  }

  # Set NVM_HOME and NVM_SYMLINK
  windows_env { 'NVM_HOME':
    ensure    => present,
    value     => 'C:\Program Files\nvm',
    mergemode => 'clobber',
  }
  windows_env { 'NVM_SYMLINK':
    ensure    => present,
    value     => 'C:\Program Files\nodejs',
    mergemode => 'clobber',
  }

  # Add Node.js and NVM to PATH
  windows_env { 'PATH=C:\Program Files\nodejs;C:\Program Files\nvm':
    ensure    => present,
    mergemode => 'append',
  }

  # Install Maven 3.9.6
  exec { 'download-maven':
    command => 'Invoke-WebRequest -Uri https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip -OutFile C:\apache-maven-3.9.6-bin.zip',
    creates => 'C:\apache-maven-3.9.6-bin.zip',
    provider => 'powershell',
  }
  exec { 'extract-maven':
    command => 'Expand-Archive -Path C:\apache-maven-3.9.6-bin.zip -DestinationPath "C:\Program Files"',
    creates => 'C:\Program Files\apache-maven-3.9.6',
    provider => 'powershell',
    require => Exec['download-maven'],
  }

  # Set MAVEN_HOME and add to PATH
  windows_env { 'MAVEN_HOME':
    ensure    => present,
    value     => 'C:\Program Files\apache-maven-3.9.6',
    mergemode => 'clobber',
  }
  windows_env { 'PATH=C:\Program Files\apache-maven-3.9.6\bin':
    ensure    => present,
    mergemode => 'append',
  }

  # Install IntelliJ IDEA Community Edition
  package { 'intellijidea-community':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Install MobaXterm
  package { 'mobaxterm':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Install Windows Subsystem for Linux (WSL)
  exec { 'install-wsl':
    command  => 'Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux',
    unless   => 'If ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled") {exit 0} else {exit 1}',
    provider => 'powershell',
  }

  # Install Visual Studio Code
  package { 'vscode':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Install Notepad++
  package { 'notepadplusplus':
    ensure   => installed,
    provider => 'chocolatey',
  }
}
