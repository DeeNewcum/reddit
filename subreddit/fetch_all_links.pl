#!/usr/bin/env perl

# Downloads all links for a specific subreddit.  Right now, it's just in JSON format.

    use strict;
    use warnings;

    use LWP::Simple;
    use JSON::XS;
    #use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements


my $subreddit = shift
        or die "please specify a Reddit subreddit\n";

my $after = undef;

my @data_children;        # all of the entries under $json->{data}{children}  on JSON responses

my $json_obj = JSON::XS->new->utf8;

my $filename_out = "$subreddit.json";
my $json_out = {data => {children => \@data_children}};

while (1) {
    my $count = scalar(@data_children);
    printf "%2d\n",     $count;
    my $url = "http://www.reddit.com/r/$subreddit/.json";
    $url .= "?count=$count&after=$after"    if defined($after);
    my $response = get $url
            or last;
    my $json = $json_obj->decode($response);
    last unless $json->{data}{children};
    push(@data_children, @{$json->{data}{children}});

    open my $fout, '>', $filename_out   or die $!;
    print $fout $json_obj->encode($json_out);
    close $fout;

    $after = $json->{data}{after}   or last;
}




