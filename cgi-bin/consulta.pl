#!/Strawberry/perl/bin/perl.exe
#/usr/bin/perl

use strict;
use warnings;
use CGI;
use utf8;

my $cgi = CGI->new;

print $cgi->header('text/html');
$cgi->charset('UTF-8');

my $opcion = $cgi->param("opcion");
my $entrada = $cgi->param("entrada");

print<<HTML;
<!DOCTYPE html>
<html>
  <head> 
    	<!--Extensión para caracteres especiales-->
		<meta charset="utf-8">

		<!--fuente de letra-->
		<link
			href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap"
			rel="stylesheet"
			type="text/css">

		<!--CSS-->
		<link rel = "stylesheet" type = "text/css" href = "/css/style.css">
    	
    	<style type="text/css">
    		body { margin: 0px; }
    	</style>

    	<title>Resultados</title>
  </head>

	<body>	
HTML


my $i = 0;
if ( !($opcion eq "") && !($entrada eq "") )
{
	print"<div class=\"cajaResultado\">";
	print"<h1>RESULTADOS</h1>";
	print"</div>";
	print"<h2 class=\"caja\">Búsqueda: $entrada</h2>";

	open(IN,"./universidades.txt") or die print "<h1>ERROR: open file</h1>\n";

	while (my $linea = <IN>)
	{
		my %dict = match($linea);
		my $valor = $dict{$opcion};

		if(defined($valor) && $valor =~ /.*$entrada.*/ && ($i % 2 == 0))
		{
	  		print "<p class=\"cajaBlanca\">$linea</p>\n";
		    $i = $i + 1;
		    next;
		}
		elsif (defined($valor) && $valor =~ /.*$entrada.*/ && ($i % 2 == 1))
		{
			print "<p class=\"cajaGris\">$linea</p>\n";
		    $i = $i + 1;
		    next;
		}
    }
}
else {
	print"<div class=\"cajaResultado\">";
	print"<h1>INGRESE DATOS ...</h1>";
	print"</div>";
}
print "</body></html>";



sub match {
	my %dict = ();
	my $linea = $_[0];

	if ( $linea =~ /\|(.*?)\|(?:.*?\|){4}(.*?)\|(?:.*?\|){5}(.*?)\|(?:.*?\|){5}(.*?)\|/ )
	{
		$dict{"nombre"} = $1;
		$dict{"licencia"} = $2;
		$dict{"departamento"} = $3;
		$dict{"denominacion"} = $4;
	}

	return %dict;
}