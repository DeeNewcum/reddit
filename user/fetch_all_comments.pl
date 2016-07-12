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

$|++;

my $json_obj = JSON::XS->new->utf8;

my %combined_data_children;

foreach my $url (
    "https://www.reddit.com/user/$username/comments.json",
    "https://www.reddit.com/user/$username/comments.json?sort=top",
    "https://www.reddit.com/user/$username/comments.json?sort=controversial",
) {
    # @data_children -- all of the entries under $json->{data}{children}  on JSON responses
    my @data_children = fetch_1000($url);

    my $new_entries = merge_data_children(\%combined_data_children, @data_children);
    print "\t$new_entries new entries\n";
    #$new_entries > 0 or last;
}

foreach my $url (
    "https://www.reddit.com/user/$username/submitted.json",
    "https://www.reddit.com/user/$username/submitted.json?sort=top",
    "https://www.reddit.com/user/$username/submitted.json?sort=controversial",
) {
    # @data_children -- all of the entries under $json->{data}{children}  on JSON responses
    my @data_children = fetch_1000($url);

    my $new_entries = merge_data_children(\%combined_data_children, @data_children);
    print "\t$new_entries new entries\n";
    #$new_entries > 0 or last;
}

my @combined_data_children;
foreach my $id (sort keys %combined_data_children) {
    push @combined_data_children, $combined_data_children{$id};
}
my $json_out = {data => {children => \@combined_data_children}};

my $filename_out = "$username.json";
open my $fout, '>', $filename_out   or die $!;
print $fout $json_obj->encode($json_out);
close $fout;



# fetch as many posts as possible, clicking "next" as many times as is necessary
sub fetch_1000 {
    my ($url) = @_;

    #(my $display_url = $url) =~ s#^.*/##;
    my $display_url = $url;
    print "======== $display_url ========\n";

    # prepare the URL for appending of the count
    if ($url =~ /\?/) {
        $url .= "&";
    } else {
        $url .= "?";
    }

    my @data_children;

    my $after = undef;
    while (1) {
        my $count = scalar(@data_children);
            #if ($count > 50) {
            #    print "REMOVE ME  (\$count > 50)\n";
            #    last;
            #}
        printf "\r                                        \r\t>  %2d",     $count;
        my $this_url = $url;
        $this_url .= "?count=$count&after=$after"    if defined($after);
        my $response = get $this_url
                or last;
        #sleep 2;
        my $json = $json_obj->decode($response);
        last unless $json->{data}{children};
        push(@data_children, @{$json->{data}{children}});

        $after = $json->{data}{after}   or last;
    }
    print "\r                                        \r";

    return @data_children;
}

sub merge_data_children {
    my ($combined_hashref, @new_data_children) = @_;

    my $num_new = 0;

    foreach my $data_child (@new_data_children) {
        my $id = $data_child->{data}{id};
        if (!exists $combined_hashref->{$id}) {
            $combined_hashref->{$id} = $data_child;
            $num_new++;
        }
    }

    return $num_new;
}
