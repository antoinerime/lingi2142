#!/usr/bin/perl

use strict;
use warnings;

use Monitoring::Plugin;
use English '-no_match_vars';

my $plugin_nagios = Monitoring::Plugin->new(
    shortname => 'Check uptime',
    usage     => 'Usage : %s [ -c|--critical=<threshold> ] [ -w|--warning=<threshold> ]',
);

if ( lc $OSNAME eq 'mswin32' ) {
    $plugin_nagios->plugin_exit( CRITICAL, "[Win32] This plugin does not work for this plateform\n" );
}

# Définition de l'argument warning
$plugin_nagios->add_arg(
    spec     => 'warning|w=f',
    help     => 'Exit with WARNING status if more than x days',
    label    => 'Days',
    required => 0,
);

# Définition de l'argument critical
$plugin_nagios->add_arg(
    spec     => 'critical|c=f',
    help     => 'Exit with CRITICAL status if more than x days',
    label    => 'Days',
    required => 0,
);

# Activer le parsing des options de ligne de commande
$plugin_nagios->getopts;

my $uptime_linux = uptime();

if ( !$uptime_linux ) {
    $plugin_nagios->plugin_exit( CRITICAL, "unable to get uptime\n" );
}

my $seuil_warning  = $plugin_nagios->opts->warning ? $plugin_nagios->opts->warning * 60 * 60 * 24 : undef;
my $seuil_critical = $plugin_nagios->opts->critical ? $plugin_nagios->opts->critical * 60 * 60 * 24 : undef;
if ( $plugin_nagios->opts->verbose ) {
    print "Uptime : $uptime_linux\n";
    if ( defined $seuil_warning ) {
        print 'WARNING threshold : ', $seuil_warning, 
            ' (', time_format( $seuil_warning ), ')', "\n";
    }
    if ( defined $seuil_critical ) {
        print 'CRITICAL threshold : ', $seuil_critical, 
            '( ', time_format( $seuil_critical ), ')', "\n";
    }

}

my $code_retour = $plugin_nagios->check_threshold(
    check    => $uptime_linux,
    warning  => $seuil_warning,
    critical => $seuil_critical,
);

$plugin_nagios->plugin_exit( $code_retour, 'Uptime - ' . time_format($uptime_linux) );

sub uptime {
    open my $fh, '<', '/proc/uptime'
      or $plugin_nagios->plugin_exit( CRITICAL, "/proc/uptime not exists, unable to get uptime\n" ), return;
    my ( $uptime, undef ) = split / /, <$fh>;
    close $fh;
    return $uptime;
}

sub time_format {
    my $totalsecondes = shift;

    if ( not defined $totalsecondes ) {
        $plugin_nagios->plugin_exit( CRITICAL, "uptime not found" );
    }
    return '0 seconde' if ( $totalsecondes == 0 );

    my $message = '';
    my ( $nbr_annees, $nbr_mois, $nbr_jours, $nbr_heures, $nbr_minutes, $nbr_secondes ) = ();

    # Annees
    my $duree_an = 60 * 60 * 24 * 30.41 * 12;
    $nbr_annees = int( $totalsecondes / $duree_an );
    if ( $nbr_annees > 0 ) {
        $totalsecondes = $totalsecondes - ( int( $totalsecondes / $duree_an ) * $duree_an );
        $message .= ( $nbr_annees == 1 ) ? "$nbr_annees year " : "$nbr_annees years ";
    }

    # Mois
    my $duree_mois = 60 * 60 * 24 * 30.41;
    $nbr_mois = int( $totalsecondes / $duree_mois );
    if ( $nbr_mois > 0 ) {
        $totalsecondes = $totalsecondes - ( int( $totalsecondes / $duree_mois ) * $duree_mois );
        $message .= ( $nbr_mois == 1 ) ? "$nbr_mois month " : "$nbr_mois months ";
    }

    # Jours
    my $duree_jours = 60 * 60 * 24;
    $nbr_jours = int( $totalsecondes / $duree_jours );
    if ( $nbr_jours > 0 ) {
        $totalsecondes = $totalsecondes - ( int( $totalsecondes / $duree_jours ) * $duree_jours );
        $message .= ( $nbr_jours == 1 ) ? "$nbr_jours day " : "$nbr_jours days ";
    }

    # Heures
    my $duree_heures = 60 * 60;
    $nbr_heures = int( $totalsecondes / $duree_heures );
    if ( $nbr_heures > 0 ) {
        $totalsecondes = $totalsecondes - ( int( $totalsecondes / $duree_heures ) * $duree_heures );
        $message .= ( $nbr_heures == 1 ) ? "$nbr_heures hour " : "$nbr_heures hours ";
    }

    # Minutes
    my $duree_minutes = 60;
    $nbr_minutes = int( $totalsecondes / $duree_minutes );
    if ( $nbr_minutes > 0 ) {
        $totalsecondes = $totalsecondes - ( int( $totalsecondes / $duree_minutes ) * $duree_minutes );
        $message .= ( $nbr_minutes == 1 ) ? "$nbr_minutes minute " : "$nbr_minutes minutes ";
    }

    # Secondes
    $totalsecondes = int $totalsecondes;
    if ( $totalsecondes > 0 ) {
        $message .= ( $totalsecondes == 1 ) ? "$totalsecondes seconde " : "$totalsecondes secondes ";
    }

    return $message;
}
