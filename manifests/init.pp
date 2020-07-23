# Install and configure Yarn
#
# @summary Install and configure Yarn
#
# @param package_ensure
#   with `present` Yarn is installed
#   with `absent` Yarn is uninstalled
# @param package_name The name of package expected to be installed with package manager provided by your OS or by npm.
# @param manage_repo
#   with `true` a new source using yarnpkg.com is added in the package manager of your OS.
#   with `false` do nothing
# @param install_method
#   with `source` the `source_url` is used to get and install Yarn
#   with `package` the package manager provider by OS is used to install Yarn
#   with `npm` the npm packahe manager is used to install Yarn
# @param source_install_dir
#   path where Yarn sources are installed with `install_method` to `source`
# @param symbolic_link the `yarn` command in the path pointing to the installed `yarn` with `install_method` to `source`
# @param user the user account on node owner of installed files with `install_method` to `source` or `npm`
# @param source_url URL where the sources are downloaded from
#
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
