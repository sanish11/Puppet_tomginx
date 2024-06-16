# Define MySQL and MySQL Workbench version and download URLs
$mysql_version = '8.0.26'
$mysql_download_url = "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-${mysql_version}-winx64.zip"

$mysql_workbench_version = '8.0.26'
$mysql_workbench_download_url = "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-${mysql_workbench_version}-winx64.msi"

# Define installation directory
$install_dir = 'C:\downloads'

# Ensure the installation directory exists
file { $install_dir:
  ensure => directory,
}

# Download MySQL installer
exec { 'download_mysql_installer':
  command => "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -command \"Invoke-WebRequest -Uri '${mysql_download_url}' -OutFile '${install_dir}\\mysql-${mysql_version}-winx64.zip'\"",
  cwd     => $install_dir,
  creates => "${install_dir}\\mysql-${mysql_version}-winx64.zip",
}

# Download MySQL Workbench installer
exec { 'download_mysql_workbench_installer':
  command => "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -command \"Invoke-WebRequest -Uri '${mysql_workbench_download_url}' -OutFile '${install_dir}\\mysql-workbench-community-${mysql_workbench_version}-winx64.msi'\"",
  cwd     => $install_dir,
  creates => "${install_dir}\\mysql-workbench-community-${mysql_workbench_version}-winx64.msi",
}
