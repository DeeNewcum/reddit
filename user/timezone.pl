#!/usr/bin/perl

# Display a histogram of when a user edits, to try to get some sense of what timezone (or at least
# hemisphere) they live in.

    use strict;
    use warnings;

    use List::Util qw(max);
    use JSON::XS;

    use FindBin;
    use lib $FindBin::Bin;
    use SprintfReddit;

    #use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements


binmode(STDOUT, ":utf8");           # SENDS UTF8 TO STDOUT

my $username = shift or die "specify a username\n";
$username =~ s/\.json$//s;


open my $fin, '<', "$username.json"     or die $!;
my $json = decode_json( do {local $/=undef; <$fin>} );

my %by_hour;
my $max_hour_count = 0;
my %by_weekday;
my $max_weekday_count = 0;
foreach my $child (@{$json->{data}{children}}) {
    my $time = $child->{data}{created_utc};
    my ($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime($time);
    #print sprintf_reddit('%u', $child), "\t$hour\n";

    $by_hour{$hour}++;      $max_hour_count = max($max_hour_count, $by_hour{$hour});
    $by_weekday{$wday}++;   $max_weekday_count = max($max_weekday_count, $by_weekday{$wday});
} 

print "Hours are in UTC.\n";
my $hour_scale_factor = 75 / $max_hour_count;
foreach my $hour (0..23) {
    printf "%2d  %s\n",
        $hour,
        '#'x(($by_hour{$hour} || 0) * $hour_scale_factor);
}

print "\n";
my $weekday_scale_factor = 75 / $max_weekday_count;
my @wday_name = qw[ Sun Mon Tue Wed Thu Fri Sat ];
foreach my $weekday (0..6) {
    printf "%3s  %s\n",
        $wday_name[$weekday],
        '#'x(($by_weekday{$weekday} || 0) * $weekday_scale_factor);
}


