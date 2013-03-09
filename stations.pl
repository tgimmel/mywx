#!/usr/bin/perl -w
use strict;

readfile();

sub readfile {
    my ($st, $city, $code, $line, @newline);
    open my $fh_station, "<", "stations.txt";
    open my $fh_list, ">", "stationlist.txt";
    
    while ($line = <$fh_station>) {
        chomp($line);
        $line =~ s/^\s+//g;             #Remove any leading space
        if ($line =~ /^\!.*/) {
            next;
        } elsif ((substr $line, 0, 6) eq "MEXICO") {
            last;
        }
        unless ($st = substr $line, 0, 2) { next; }
        $city = substr $line, 3, 16;
        $code = substr $line, 20, 4;
        if ($code eq "IACO") {
            next;
            } elsif ($code =~ /\d-\S\S/) {   #portion of date 7-JU
            next;
        } elsif ($code eq "    ") {
            next;
        }
        print $fh_list "$st $city $code\n";
        
    }
}

