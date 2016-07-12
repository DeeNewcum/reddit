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


my $json_obj = JSON::XS->new->utf8;

my $filename_out = "$username.json";

# all of the entries under $json->{data}{children}  on JSON responses
my @data_children = fetch_1000("http://www.reddit.com/user/$username/.json");

my $json_out = {data => {children => \@data_children}};

open my $fout, '>', $filename_out   or die $!;
print $fout $json_obj->encode($json_out);
close $fout;



# fetch as many posts as possible, clicking "next" as many times as is necessary
sub fetch_1000 {
    my ($url) = @_;

    # prepare the URL for appending of the count
    if ($url =~ /\?/) {
        $url .= "&";
    } else {
        $url .= "?";
    }

    my @data_children;

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

        $after = $json->{data}{after}   or last;
    }

    return @data_children;
}
