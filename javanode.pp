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

  # Install Git
  package { 'git':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Install Node.js using Chocolatey
  package { 'nodejs-lts':
    ensure   => installed,
    provider => 'chocolatey',
  }

  # Install Angular CLI versions
  exec { 'install-angular-8':
    command => '"C:\Program Files\nodejs\npm.cmd" install -g @angular/cli@8',
    require => Package['nodejs-lts'],
  }

  exec { 'install-angular-16':
    command => '"C:\Program Files\nodejs\npm.cmd" install -g @angular/cli@16',
    require => Package['nodejs-lts'],
  }

  exec { 'install-angular-20':
    command => '"C:\Program Files\nodejs\npm.cmd" install -g @angular/cli@20',
    require => Package['nodejs-lts'],
  }

  # Set JAVA_HOME environment variable
  exec { 'set-java-home':
    command => 'setx JAVA_HOME "C:\\Program Files\\Java\\jdk1.8.0_291"',
    unless  => 'reg query "HKCU\\Environment" /v JAVA_HOME',
    path    => 'C:\Windows\System32',
  }

  # Install Maven 3.9.6
  exec { 'download-maven':
    command => 'Invoke-WebRequest -Uri https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip -OutFile C:\apache-maven-3.9.6-bin.zip',
    creates => 'C:\apache-maven-3.9.6-bin.zip',
    path    => 'C:\Windows\System32',
  }

  exec { 'extract-maven':
    command => 'Expand-Archive -Path C:\apache-maven-3.9.6-bin.zip -DestinationPath "C:\\Program Files"',
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
