#!/usr/bin/env perl

# Downloads all comments for a specific user.  Right now, it's just in JSON format.
#
# NOTE: this only downloads the first 1000 comments, see:
#               http://www.reddit.com/r/ideasfortheadmins/comments/10tai6/#c6gicdf

    use strict;
    use warnings;

    use LWP::Simple;
    use JSON::XS;
    #use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements


my $username = shift
        or die "please specify a Reddit username\n";
$username =~ s#^https?://([^/]+\.)?reddit\.com/user/##;

my $after = undef;

my @data_children;        # all of the entries under $json->{data}{children}  on JSON responses

my $json_obj = JSON::XS->new->utf8;

my $filename_out = "$username.json";
my $json_out = {data => {children => \@data_children}};

while (1) {
    my $count = scalar(@data_children);
    printf "%2d\n",     $count;
    my $url = "http://www.reddit.com/user/$username/.json";
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




