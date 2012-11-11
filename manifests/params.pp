# == Class: tor::params
#
# This class handles OS-specific configuration of the tor module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class tor::params {
  # Customize these values if you (for example) mirror public YUM repos to your
  # internal network.
  $yum_server   = 'http://deb.torproject.org'
  $yum_path     = '/torproject.org/rpm'
  $yum_priority = '50'
  $yum_protect  = '0'

### The following parameters should not need to be changed.

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $ensure = $::tor_ensure ? {
    undef   => 'present',
    default => $::tor_ensure,
  }

  $package_name = $::tor_package_name ? {
    undef   => 'tor',
    default => $::tor_package_name,
  }

  $file_name = $::tor_file_name ? {
    undef   => '/etc/tor/torrc',
    default => $::tor_filee_name,
  }

  $service_ensure = $::tor_service_ensure ? {
    undef   => 'running',
    default => $::tor_service_ensure,
  }

  $service_name = $::tor_service_name ? {
    undef   => 'tor',
    default => $::tor_service_name,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $autoupgrade = $::tor_autoupgrade ? {
    undef   => false,
    default => $::tor_autoupgrade,
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $service_enable = $::tor_service_enable ? {
    undef   => true,
    default => $::tor_service_enable,
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $service_hasrestart = $::tor_service_hasrestart ? {
    undef   => true,
    default => $::tor_service_hasrestart,
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  $service_hasstatus = $::tor_service_hasstatus ? {
    undef   => true,
    default => $::tor_service_hasstatus,
  }
  if is_string($service_hasstatus) {
    $safe_service_hasstatus = str2bool($service_hasstatus)
  } else {
    $safe_service_hasstatus = $service_hasstatus
  }

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'Fedora': {
          $baseurl_string = 'fc'  # must be lower case
        }
        default: {
          $baseurl_string = 'el'  # must be lower case
        }
      }
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}