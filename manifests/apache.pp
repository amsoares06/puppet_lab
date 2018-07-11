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
