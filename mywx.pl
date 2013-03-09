#!/usr/bin/perl -w

use strict;
use Geo::WeatherNWS;
use Getopt::Std;


my ($winddirtext, $nochill, $debug, $station, $default);
$debug = 0;
$default = 'Henderson, KY';
our ($opt_d, $opt_s, $opt_h);
getopts('dhs:');
if ($opt_d) { $debug = 1; }
if ($opt_s) { $station = $opt_s;}
if ($opt_h) { usage();}

$nochill = "0";
$station  = $ARGV[0];
if (!$station) { print "No station entered, using default location, $default\n"; }
my $Report = Geo::WeatherNWS::new();

$Report->setservername("tgftp.nws.noaa.gov");
$Report->setusername("anonymous");
if ($station) {
    $Report->getreport($station);
      if ($Report->{error}) {
        print "$Report->{errortext}";
        print "Check code or try again later.\n";
        exit;
      }
} else {
    $Report->getreport('kehr');
}
#$Report->getreport('kehr');      #Henderson, KY
#$Report->getreport('kpwa');       #Wiley Post Airport, OKC

if ($Report->{error})
  {
    print "$Report->{errortext}";
  }
#$winddirtext = $Report->{winddirtext};
#if ($winddirtext eq "Calm") { $nochill = "1"; }
print "\n";
if ($debug) { print "debug: $Report->{obs}\n"; }
print "================================================================\n";
print "  WX report from station $Report->{code} \@$Report->{report_date} $Report->{report_time} UTC\n";
print "================================================================\n";
printf "Temperture:%3u degrees             Air Pressure:%2.2f Inches hg\n", $Report->{temperature_f}, $Report->{pressure_inhg};
printf " Windspeed:%3u mph from %-9s  Guest %s mph \n", $Report->{windspeedmph}, $Report->{winddirtext}, $Report->{windgustmph};
printf "  Dewpoint:%3u degrees             Relative humidity:%u%% \n", $Report->{dewpoint_f}, $Report->{relative_humidity};
if ($Report->{windchill_f}) { printf " Windchill:%3u degrees", $Report->{windchill_f} } else { print "  No Windchill Report "; }
if ($Report->{heat_index_f} and ($Report->{temperature_f} > 60)) {
    printf "             Heat Index:%3u \n", $Report->{heat_index_f};
    } else { print "             No Heat Index Report\n"; }
if ($Report->{cloudcover}) {printf "Cloudcover: %s \n", $Report->{cloudcover}; }
print "================================================================\n";
print "Find your code at http://www.aircharterguide.com/Airports \n";
print "================================================================\n";

sub usage {
    print "USAGE: mywx [-d] <METAR>\n";
    print " -d debug\n";
    print "<METAR> is 4 character metar code\n";
}