#!/usr/bin/perl
#/Strawberry/perl/bin/perl.exe

# Modulos
use strict;
use warnings;
use CGI;
use utf8;
use Encode;

# CGI
my $cgi = CGI->new;

print $cgi->header('text/html');
      $cgi->charset('UTF-8');

# Obtencion de datos
my $opcion  = $cgi->param("opcion");
my $entrada = $cgi->param("entrada");
   $entrada = decode('UTF-8', $entrada);

print<<HTML;
<!DOCTYPE html>
<html>
  	<head>
		<!--fuente de letra-->
		<link
			href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap"
			rel="stylesheet"
			type="text/css">

		<!--CSS-->
		<link rel = "stylesheet" type = "text/css" href = "/css/style.css">
    	
		<!--Style-->
		<style type="text/css">
			body { margin: 0px 0px 100px; }
		</style>

		<title>Resultados</title>
	</head>
	
	<body>	
HTML

# Iteraciones | contador
my $i = 0;

# Verificacion de datos vacios
if ( !($entrada eq "") )
{
	# Titulo de Resultados | Informacion de busqueda 
	print "\t\t<div class=\"cajaResultado\">\n";
	print "\t\t\t<h1>RESULTADOS</h1>\n";
	print "\t\t</div>\n\n";
	print "\t\t<h2 class=\"caja\">Búsqueda: $entrada</h2>\n\n";

	# Abrir archivo
	open my $archivo, "<:encoding(UTF-8)", "./universidades.txt" or die print "\t\t<h2 class=\"caja\">Error abriendo el archivo</h2>\n\n";

	# Lectura linea por linea
	while (my $linea = <$archivo>)
	{
		# Uso de funcion Match y Arreglo Asociativo
		my %dict  = match($linea);
		my $valor = $dict{$opcion};

		# Verificacion de si es opcion licencia para una busqueda mas estricta
		if ( !($opcion eq "licencia") )
		{
			# Si hay match se muestra | Dos condicionales para intercalado
			if( defined($valor) && $valor =~ /.*$entrada.*/i && ($i % 2 == 0) )
			{
		  		print "\t\t<p class=\"cajaBlanca\">$linea</p>\n";
			    $i++;
			    next;
			}
			elsif ( defined($valor) && $valor =~ /.*$entrada.*/i && ($i % 2 == 1) )
			{
				print "\t\t<p class=\"cajaGris\">$linea</p>\n";
			    $i++;
			    next;
			}
		}
		else
		{
			# Busqueda estricta
			if( defined($valor) && $valor eq $entrada && ($i % 2 == 0) )
			{
		  		print "\t\t<p class=\"cajaBlanca\">$linea</p>\n";
			    $i++;
			    next;
			}
			elsif ( defined($valor) && $valor eq $entrada && ($i % 2 == 1) )
			{
				print "\t\t<p class=\"cajaGris\">$linea</p>\n";
			    $i++;
			    next;
			}
		}
    }
    close $archivo;
}
else
{
	# En dado caso no se ingrese nada
	print "\t\t<div class=\"cajaResultado\">\n";
	print "\t\t\t<h1>INGRESE DATOS ...</h1>\n";
	print "\t\t</div>\n";
}

# Cierre del HTML
print "\t\t<h2 class=\"caja\">Cantidad de Resultados: $i</h2>\n";
print "\t</body>\n";
print "</html>";

#Funcion
sub match
{
	my %dict = ();
	my $linea = $_[0];

	# Obtener los datos de la expresion
	if ( $linea =~ /\|(.*?)\|(?:.*?\|){4}(.*?)\|(?:.*?\|){5}(.*?)\|(?:.*?\|){5}(.*?)\|/ )
	{
		$dict{"nombre"}		  = $1;
		$dict{"licencia"}	  = $2;
		$dict{"departamento"} = $3;
		$dict{"denominacion"} = $4;
	}

	return %dict;
}
