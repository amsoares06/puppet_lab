group { 'gerencia':
	ensure => 'present',
	gid => '501',
}

user { 'bemer':
  ensure           => 'present',
  comment          => 'Bruno Emer',
  groups           => [ 'sudo', 'gerencia' ],
  home             => '/home/bemer',
  managehome       => 'true',
  shell            => '/bin/bash',
  uid              => '10001',
  purge_ssh_keys   => true,
  password => '$6$Hymg6ZiZ$flzGQibOM.SjOjawugOz7c00BqR8.uegAe/1yRXyA0tpK/JraFnbeCsoxA0HDes68buZyRF3sOFUHZ0gcTK2o0',
}

ssh_authorized_key { 'bemer_key':
  user => 'bemer',
  type => 'ssh-rsa',
  key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDDd7C8X+jquuS3TOrEO9xWqFo29xNYWdCoJ7bE8rDCaypPsQPkw1MMJKe3+Pzk74MqCfc9hZiOAy34FdffjEEA3w48zMIKIqoW+xh+7Fe1u0PEX4LSccjcA20F/SGIaoqsIuq8vDK3NEw/HY4VpLHyl9UGcupHDFntRmCmE1jCoZLBrB+3OdZ904t1MVq/Drk5QgKh/IUsr/ixBLrwlepx5MJ9M7PidCcT0ppeGwZFLPgowO1JAVaa2hQ1M27vCr/fcBFprqftZrp3NeYIqtJPhb/dgS/sPP41mflIuzofmGfddGLzz7ylK3xGNz+I4WZcJ2VA8QYzojT9GipFi0VT',
}