# See README.md for usage information
class yarn (
  Enum['present','absent'] $package_ensure = $yarn::params::package_ensure,
  String[1] $package_name = $yarn::params::package_name,
  Boolean $manage_repo = $yarn::params::manage_repo,
  Enum['npm', 'source', 'package'] $install_method = $yarn::params::install_method,
  Stdlib::Absolutepath $source_install_dir = $yarn::params::source_install_dir,
  Stdlib::Absolutepath $symbolic_link = $yarn::params::symbolic_link,
  String[1] $user = $yarn::params::user,
  Stdlib::HTTPUrl $source_url = $yarn::params::source_url
) inherits yarn::params {

  include stdlib

  anchor { 'yarn::begin': }

  -> class { 'yarn::repo':
    manage_repo  => $manage_repo,
    package_name => $package_name,
  }

  ~> class { 'yarn::install':
    package_ensure     => $package_ensure,
    package_name       => $package_name,
    install_method     => $install_method,
    source_install_dir => $source_install_dir,
    symbolic_link      => $symbolic_link,
    user               => $user,
    source_url         => $source_url,
  }

  -> anchor { 'yarn::end': }

}
