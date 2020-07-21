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
  $package_ensure     = $yarn::params::package_ensure,
  $package_name       = $yarn::params::package_name,
  $manage_repo        = $yarn::params::manage_repo,
  $install_method     = $yarn::params::install_method,
  $source_install_dir = $yarn::params::source_install_dir,
  $symbolic_link      = $yarn::params::symbolic_link,
  $user               = $yarn::params::user,
  $source_url         = $yarn::params::source_url
) inherits yarn::params {

  include stdlib

  validate_string($package_ensure)
  validate_string($package_name)
  validate_string($source_install_dir)
  validate_string($symbolic_link)
  validate_string($user)
  validate_string($source_url)
  validate_bool($manage_repo)
  validate_re($install_method, [ '^npm$', '^source$', '^package$' ],  'The $install_method only accepts npm, source or package as values')

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
