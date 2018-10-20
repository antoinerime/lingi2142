#!/usr/bin/perl -w

use strict;
use warnings;

#$test = exec("sudo birdc6 -s /tmp/Michotte_bird6.ctl 'show protocols all");
my $bird = "sudo birdc6 -s /tmp/Michotte_bird6.ctl";
#my $final_result_line = exec($bird." show route count");
my $final_result_line2 = exec($bird." show protocols all");
#my @result_lines = $bird->long_cmd("show route protocol kernel");

#print "$final_result_line \n \n" ;
print "$final_result_line2 \n" ;
