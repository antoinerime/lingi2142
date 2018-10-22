#!/usr/bin/perl
#===============================================================================
# Auteur : djibril
# Date   : 29/10/2013
# But    : Check Memory and Swap on Linux/Unix
#===============================================================================
use strict;
use warnings;

use Monitoring::Plugin;
use English '-no_match_vars';
use Sys::MemInfo qw/availkeys/;
use vars qw/ $VERSION /;

# Version du plugin
$VERSION = '1.0';

my $LICENCE = 'This Plugin is free';

my $plugin_nagios = Monitoring::Plugin->new(
    shortname => 'Check memory',
    usage     => 'Usage : %s [ -c|--critical=<threshold> ] [ -w|--warning=<threshold> ] [ -M|--memory=<mem or swap> ]',
    version   => $VERSION,
    license   => $LICENCE,
);

if ( lc $OSNAME eq 'mswin32' ) {
    $plugin_nagios->plugin_exit( CRITICAL, "[Win32] This plugin does not work for this plateform\n" );
}

# Activer gestion mémoire swap
$plugin_nagios->add_arg(
    spec     => 'memory|M=s',
    help     => 'type of memory : swap or mem',
    required => 1,
);

# Définition de l'argument warning
$plugin_nagios->add_arg(
    spec     => 'warning|w=f',                                               # Nous acceptons des nombres réels
    help     => 'Exit with WARNING status if more than pourcentage',
    required => 1,
);

# Définition de l'argument critical
$plugin_nagios->add_arg(
    spec     => 'critical|c=f',
    help     => 'Exit with CRITICAL status if more than pourcentage',
    required => 1,
);

# Activer le parsing des options de ligne de commande
$plugin_nagios->getopts;
my %memory = map { $_ => Sys::MemInfo::get($_) } availkeys();

my $percent_memory_used = $plugin_nagios->opts->memory eq 'swap' ? sprintf '%.2f', (($memory{totalswap} - $memory{freeswap})/$memory{totalswap}) * 100 
    : sprintf '%.2f', (($memory{totalmem} - $memory{freemem})/$memory{totalmem}) * 100
    ;

my $message_memory = $plugin_nagios->opts->memory eq 'swap' ? 
      'Total Memory Swap : ' . sprintf('%.2f',($memory{totalswap}/(1024*1024))) . 'MB - Swap used : ' . $percent_memory_used . '%'
    : 'Total Memory : ' . sprintf('%.2f',($memory{totalmem}/(1024*1024))) . 'MB - Mem used : ' . $percent_memory_used . '%'
    ;
if ( $plugin_nagios->opts->verbose ) {
    while ( my ($key, $value) = each %memory ) {
        print "$key : $value\n";
    }
}

my $code_retour = $plugin_nagios->check_threshold(
    check    => $percent_memory_used,
    warning  => $plugin_nagios->opts->warning,
    critical => $plugin_nagios->opts->critical,
);

$plugin_nagios->plugin_exit( $code_retour, $message_memory );
