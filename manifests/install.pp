# Install Yarn
#
# @summary Install Yarn
#
# @param package_ensure
#   with `present` Yarn is installed
#   with `absent` Yarn is uninstalled
# @param package_name The name of package expected to be installed with package manager provided by your OS or by npm.
# @param install_method
#   with `source` the `source_url` is used to get and install Yarn
#   with `package` the package manager provider by OS is used to install Yarn
#   with `npm` the npm packahe manager is used to install Yarn
# @param source_install_dir
#   path where Yarn sources are installed with `install_method` to `source`
# @param symbolic_link the `yarn` command in the path pointing to the installed `yarn` with `install_method` to `source`
# @param user
#   the user account that own installed files with `install_method` to `source` or `npm`.
#   this module does not create it and need to be already existing.
# @param source_url URL where the sources are downloaded from
#
# @api private
#
class yarn::install (
  $package_ensure,
  $package_name,
  $install_method,
  $source_install_dir,
  $symbolic_link,
  $user,
  $source_url,
) {
  assert_private()

  Exec {
    path   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  $install_dir = "${source_install_dir}/yarn"

  case $install_method {
    'source': {
      if ($package_ensure == 'absent') {
        file { $symbolic_link:
          ensure => 'absent',
        }

        -> file { $install_dir:
          ensure => 'absent',
          force  => true,
        }
      }
      else {
        ensure_packages(['wget', 'gzip', 'tar'])

        file { $install_dir:
          ensure => 'directory',
          owner  => $user,
        }

        -> exec { "wget ${source_url}":
          command => "wget ${source_url} -O yarn.tar.gz",
          cwd     => $install_dir,
          user    => $user,
          creates => "${install_dir}/yarn.tar.gz",
          require => Package['wget'],
        }

        -> exec { 'tar zvxf yarn.tar.gz':
          command => 'tar zvxf yarn.tar.gz',
          cwd     => $install_dir,
          user    => $user,
          creates => "${install_dir}/dist",
          require => Package['gzip', 'tar'],
        }

        -> file { $symbolic_link:
          ensure => 'link',
          owner  => $user,
          target => '/opt/yarn/dist/bin/yarn',
        }
      }
    }

    'npm': {
      if ($package_ensure == 'absent') {
        exec { "npm uninstall -g ${package_name}":
          user     => $user,
          command  => "npm uninstall -g ${package_name}",
          onlyif   => "npm list -depth 0 -g ${package_name}",
          provider => shell,
        }
      }
      else {
        exec { "npm install -g ${package_name}":
          user     => $user,
          command  => "npm install -g ${package_name}",
          unless   => "npm list -depth 0 -g ${package_name}",
          provider => shell,
        }
      }
    }

    default: {
      package{ $package_name:
        ensure => $package_ensure,
      }
    }
  }

}
