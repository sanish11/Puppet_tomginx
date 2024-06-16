#Puppet Domain Specific Language(DSL)
# Define installation directory
$install_dir = 'C:\test'
$tomcat_version = '9.0.81'
$tomcat_installer_url = "https://archive.apache.org/dist/tomcat/tomcat-9/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.exe"
$tomcat_installer_path = "${install_dir}\\apache-tomcat-${tomcat_version}.exe"
$nginx_version = '1.21.6'
$nginx_zip_url = "https://nginx.org/download/nginx-${nginx_version}.zip"
$nginx_zip_path = "${install_dir}\\nginx.zip"
$nginx_extracted_path = "${install_dir}\\nginx-${nginx_version}"
$mssql_installer_url = 'https://go.microsoft.com/fwlink/?linkid=866658'
$mssql_installer_path = "${install_dir}\\SQL2019-SSEI-Dev.exe"
$mssql_install_path = "${install_dir}\\MSSQL"

# Ensure the installation directory exists
file { $install_dir:
  ensure => directory,
}

# Download Tomcat Windows Service Installer
exec { 'download_tomcat_installer':
  command => "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -command \"Invoke-WebRequest -Uri '${tomcat_installer_url}' -OutFile '${tomcat_installer_path}'\"",
  cwd     => $install_dir,
  creates => $tomcat_installer_path,
  require => File[$install_dir],
}
# Download NGINX
exec { 'download_nginx':
  command => "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -command \"Invoke-WebRequest -Uri '${nginx_zip_url}' -OutFile '${nginx_zip_path}'\"",
  cwd     => $install_dir,
  creates => $nginx_zip_path,
  require => File[$install_dir],
}

# Extract NGINX
exec { 'extract_nginx':
  command => "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -command \"Expand-Archive -Path '${nginx_zip_path}' -DestinationPath '${install_dir}'\"",
  require => Exec['download_nginx'],
  creates => $nginx_extracted_path,
}
# Download SQL Server Installer
exec { 'download_mssql_installer':
  command => "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -command \"Invoke-WebRequest -Uri '${mssql_installer_url}' -OutFile '${mssql_installer_path}'\"",
  cwd     => $install_dir,
  creates => $mssql_installer_path,
  require => File[$install_dir],
}



# Notify after installation
notify { 'Tomcat installed':
  message => "Tomcat ${tomcat_version} has been successfully installed and started.",
}
