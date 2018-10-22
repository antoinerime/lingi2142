#!/usr/bin/perl

use warnings;
use strict;
use Monitoring::Plugin;
use Proc::ProcessTable;

my $plugin_nagios = Monitoring::Plugin->new(
    shortname => 'Check process',
    usage     => 'Usage: %s [ -proc_name|-n=<Process name> ] [ -path|-p=<Path> ]',
);

# Définition des options de ligne de commande
# 1- Récupération du nom du processus
$plugin_nagios->add_arg(
    spec     => 'proc_name|n=s',
    help     => 'Process name',
    label    => 'STRING',
    required => 1,
);

# 2- CmdLine du processus
$plugin_nagios->add_arg(
    spec     => 'path|p=s',
    help     => 'Command line of process',
    label    => 'STRING',
    required => 0,
);

# Parser les options
$plugin_nagios->getopts;

# Recherche du processus
my $process_table = new Proc::ProcessTable;

my $proc_name = $plugin_nagios->opts->proc_name;

PROC:
foreach my $proc ( @{ $process_table->table } ) {
    if ( $proc->fname eq $proc_name ) {
        my $message_OK = "Process $proc_name (" . $proc->pid . ') state (' . $proc->state . ')';

        # Path definie par nagios
        if ( my $path = $plugin_nagios->opts->path and $plugin_nagios->opts->path !~ m{^\s*$} ) {
            if ( $proc->cmndline ne $path ) {
                $plugin_nagios->plugin_exit( WARNING, "Process $proc_name exists but not path : $path" );
                last PROC;
            }
            $plugin_nagios->plugin_exit( OK, $message_OK );
        }
        $plugin_nagios->plugin_exit( OK, $message_OK );
    }
}

$plugin_nagios->plugin_exit( CRITICAL, "$proc_name not found" );
