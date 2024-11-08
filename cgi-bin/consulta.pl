#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use utf8;

print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
  <head> 
    <meta charset="utf-8"> 
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <title>Resultado</title>
  </head>
<body>
HTML


my $cgi = CGI->new;
my $opcion = $cgi->param("opcion");
my $entrada = $cgi->param("entrada");

my $flag;
if ( !($opcion eq "") && !($entrada eq "") )
{
	open(IN,"./universidades.txt") or die "<h1>ERROR: open file</h1>\n";

	while (my $linea = <IN>)
	{
		my %dict = match($linea);
		my $valor = $dict{$opcion};

		if(defined($valor) && $valor =~ /.*$entrada.*/)
		{
		    print "<h1>Encontrado: $line</h1>\n";
		    $flag = 1;
		    next;
		}
    }
}

sub match {
	my %dict = ();
	my $linea = $_[0];

	if ( $linea =~ /.*\|(.*)\| [.*\|]{4} (.*)\| [.*\|]{5} (.*)\| [.*\|]{5} (.*)\| / )
	{
		$dict{"nombre"} = $1;
		$dict{"licencia"} = $2;
		$dict{"departamento"} = $3;
		$dict{"denominacion"} = $4;
	}
	else
	{
		print "<h1>Error la linea no hace match: $linea</h1>\n";
	}

	return %dict;
}