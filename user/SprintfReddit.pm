# provides sprintf-formatting functionality for Reddit "thing"s.

package SprintfReddit;

    use strict;
    use warnings;

    use Data::Dumper;

    use Exporter qw(import);
    our @EXPORT = qw(sprintf_reddit);

    use String::Formatter
        stringf => {
            -as => 'formatter_sprintfreddit',
            codes => {
                s => \&percent_s,       # score
                u => \&percent_u,       # URL
            },
        };


sub sprintf_reddit {
    my ($format, $thing) = @_;
    #die Dumper $thing;
    return formatter_sprintfreddit($format, map {$thing} 1..99);
}


# score
sub percent_s {
    my $json = $_;
    if ($json->{kind} eq 't1') {        # comment
        return int(
                ($json->{data}{ups} || 0)
              - ($json->{data}{downs} || 0)    );
    } else {
        die;
    }
}


# URL
sub percent_u {
    my $json = $_;
    if ($json->{kind} eq 't1') {        # comment
        return
            "http://reddit.com/r/" . $json->{data}{subreddit} . "/comments/" .
            reddit_id_only($json->{data}{link_id}) . "/-/" . $json->{data}{id};
    } elsif ($json->{kind} eq 't3') {       # story
        return $json->{data}{url};
    } elsif ($json->{kind} eq 't5') {       # subreddit
        die;
    }
}


sub reddit_id_only {
    my $id = shift;
    $id =~ s/^t\d_//;
    return $id;
}


1;
