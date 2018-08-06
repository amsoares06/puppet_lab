![fiap logo](/images/fiap_logo.jpg)

# Trabalho final


## Pré-requisitos

O sistema operacional utilizado nesse lab foi o `Linux Ubuntu Server 16.04 LTS`.

A configuração do Puppet Master e Client, seguiu os itens 1, 2 e 3 do procedimento usado em sala de aula:

https://github.com/bemer/lab-24ati/tree/master/09-ComecandoComPuppet

Estando com o Puppet Master e Client configurados e o certificado assinado no Master, prosseguiremos com os manifestos.

Os arquivos `.pp` encontram-se no diretório `manifests` desse repositório.


## Criando o usuário e configurando o sudo

Para a criação do grupo e senha de acesso, copiar o arquivo `user.pp` para o diretório `/etc/puppetlabs/code/environments/production/manifests/` do `Puppet Master`

user.pp:

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
	  key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDDd7C8X+jquuS3TOrEO9xWqFo29xNYWdCoJ7bE8rDCaypPsQPkw1MMJKe3	+Pzk74MqCfc9hZiOAy34FdffjEEA3w48zMIKIqoW+xh+7Fe1u0PEX4LSccjcA20F/SGIaoqsIuq8vDK3NEw/HY4VpLHyl9UGcupHDFntRmCmE1jCoZLBrB	+3OdZ904t1MVq/Drk5QgKh/IUsr/ixBLrwlepx5MJ9M7PidCcT0ppeGwZFLPgowO1JAVaa2hQ1M27vCr/fcBFprqftZrp3NeYIqtJPhb/dgS/sPP41mflIuzofmG	fddGLzz7ylK3xGNz+I4WZcJ2VA8QYzojT9GipFi0VT',
	}


Esse código criará um grupo chamado `gerencia`, um usuário `bemer` dentros dos grupos `gerencia` e `sudo` para ter acesso de root através do comando `sudo`. Será configurada também a senha e uma chave pública para o usuário `bemer`, para acesso usando a chave privada `bemer_key` que se encontra nesse repositório. Essa chave privada encontra-se no diretório `resources` desse repositório.

> OBS: é necessário que o grupo `sudo` tenha permissões concedidas no arquivo `/etc/sudoers`, essa é uma configuração padrão do Ubuntu 16.04 LTS.

Para testar basta logar no `Puppet Client`:

	$ ssh -i bemer_key bemer@<IP do puppetclient>
	$ id
	uid=10001(bemer) gid=10001(bemer) groups=10001(bemer),27(sudo),501(gerencia)
	$ sudo -l
	User bemer may run the following commands on puppetclient:
    (ALL : ALL) ALL

Caso prefira a senha do usuário `bemer` é `abc123`.


## Instalando e alterando a porta do SSH

Para a configuração do SSH, precisaremos instalar um módulo externo a partir do `Puppet Forge`, para isso, no `Puppet Master`, basta rodar o comando abaixo:

	$ sudo /opt/puppetlabs/bin/puppet module install ghoneycutt-ssh

A saída do comando deve ser:

	Notice: Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
	Notice: Downloading from https://forgeapi.puppet.com ...
	Notice: Installing -- do not interrupt ...
	/etc/puppetlabs/code/environments/production/modules
	└─┬ ghoneycutt-ssh (v3.57.0)
	├── ghoneycutt-common (v1.7.0)
	├── puppetlabs-concat (v4.2.1)
	├── puppetlabs-firewall (v1.12.0)
	└── puppetlabs-stdlib (v4.25.1)


Maiores informações sobre esse módulo podem ser encontradas no site Puppet Forge:

https://forge.puppet.com/ghoneycutt/ssh

Depois de instalado o módulo do ssh, colocar o arquivo `ssh.pp` no diretório `/etc/puppetlabs/code/environments/production/manifests/` do `Puppet Master`: 

ssh.pp:

	class { 'ssh':
	  sshd_config_port => '2222',
	}


Esse código alterará a porta do SSH da padrão `22` para uma porta alta `2222`. Caso o SSH server não esteja instalado, ele será instalado. Para testar basta usar o comando abaixo ao logar no `Puppet Client`:

	$ ssh -i bemer_key -p 2222 bemer@puppetclient


## Apache e configurações de Virtual Hosts

Para o Apache também é necessária a instalação de um módulo extra no `Puppet Master`:

	$ sudo /opt/puppetlabs/bin/puppet module install puppetlabs-apache

Saída:

	Notice: Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
	Notice: Downloading from https://forgeapi.puppet.com ...
	Notice: Installing -- do not interrupt ...
	/etc/puppetlabs/code/environments/production/modules
	└─┬ puppetlabs-apache (v3.2.0)
	├── puppetlabs-concat (v4.2.1)
	└── puppetlabs-stdlib (v4.25.1)

Depois de instalado o módulo, é necessário copiar o arquivo `apache.pp`

apache.pp:

	class { 'apache': }
	  apache::vhost { 'desenvolvimento':
	    servername => 'www.desenvolvimento.com.br',
	    port    => '80',
	    docroot => '/var/www/html/dev'
	  }
	
	  apache::vhost { 'homologacao':
	    servername => 'www.homologacao.com.br',
	    port    => '80',
	    docroot => '/var/www/html/hml'
	  }
	
	  apache::vhost { 'producao':
	    servername => 'www.producao.com.br',
	    port    => '80',
	    docroot => '/var/www/html/prd'
	  }
	
	  file { '/var/www/html/dev/index.html':
	    ensure  => 'present',
	    content => "<h1><strong>DESENVOLVIMENTO</strong></h1>
	<table style=\"width: 274.717px;\">
	<tbody>
	<tr>
	<td style=\"width: 178px;\">Alexandre Esmeria</td>
	<td style=\"width: 98.7167px; text-align: right;\">41562</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Alexandre Soares</td>
	<td style=\"width: 98.7167px; text-align: right;\">42381</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Leonardo Escatena</td>
	<td style=\"width: 98.7167px; text-align: right;\">42496</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Simey Bertacchi</td>
	<td style=\"width: 98.7167px; text-align: right;\">41134</td>
	</tr>
	</tbody>
	</table>
	<p>&nbsp;</p>
	<hr>
	<p>24ATI</p>"
	  }
	
	  file { '/var/www/html/hml/index.html':
	    ensure  => 'present',
	    content => "<h1><strong>HOMOLOGACAO</strong></h1>
	<table style=\"width: 274.717px;\">
	<tbody>
	<tr>
	<td style=\"width: 178px;\">Alexandre Esmeria</td>
	<td style=\"width: 98.7167px; text-align: right;\">41562</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Alexandre Soares</td>
	<td style=\"width: 98.7167px; text-align: right;\">42381</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Leonardo Escatena</td>
	<td style=\"width: 98.7167px; text-align: right;\">42496</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Simey Bertacchi</td>
	<td style=\"width: 98.7167px; text-align: right;\">41134</td>
	</tr>
	</tbody>
	</table>
	<p>&nbsp;</p>
	<hr>
	<p>24ATI</p>"
	  }
	
	  file { '/var/www/html/prd/index.html':
	    ensure  => 'present',
	    content => "<h1><strong>PRODUCAO</strong></h1>
	<table style=\"width: 274.717px;\">
	<tbody>
	<tr>
	<td style=\"width: 178px;\">Alexandre Esmeria</td>
	<td style=\"width: 98.7167px; text-align: right;\">41562</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Alexandre Soares</td>
	<td style=\"width: 98.7167px; text-align: right;\">42381</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Leonardo Escatena</td>
	<td style=\"width: 98.7167px; text-align: right;\">42496</td>
	</tr>
	<tr>
	<td style=\"width: 178px;\">Simey Bertacchi</td>
	<td style=\"width: 98.7167px; text-align: right;\">41134</td>
	</tr>
	</tbody>
	</table>
	<p>&nbsp;</p>
	<hr>
	<p>24ATI</p>"
	}

Esse arquivo instalará o apache, criará os Virtual Hosts para os ambientes de desenvolvimento, homologação e produção e criará um index.html simples para cada um dos três ambientes.

Para o teste, basta alterar o arquivo de hosts da sua máquina e incluir a seguinte entrada:

	<IP do puppet client>        www.desenvolvimento.com.br      www.homologacao.com.br  www.producao.com.br
	
Feito isso abrir um navegador e ir até as URL's:

* www.desenvolvimento.com.br
* www.homologacao.com.br
* www.producao.com.br

Cada URL deve responder com uma página diferente indicando a qual ambiente aquele site pertence.


:shipit:
