#!/usr/bin/perl

# search an already-downloaded JSON file (obtained via fetch_all_comments.pl) to see which comments
# match the specified regexp

    use strict;
    use warnings;

    use JSON::XS;
    our $filename;
    BEGIN {
        $filename = shift @ARGV;
    }
    use Getopt::Casual;

    use FindBin;
    use lib $FindBin::Bin;
    use SprintfReddit;

    #use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements




sub usage {$/=undef; die <DATA>}
defined($filename) or usage();
$filename =~ s/\.json$//s;
if ($ARGV{'--dump'}) {
    print Dumper $filename, \%ARGV;
    exit;
}


open my $fin, '<', "$filename.json"     or die $!;
my $json = decode_json( do {local $/=undef; <$fin>} );

foreach my $child (@{$json->{data}{children}}) {
    if ($ARGV{'-s'}) {
        next unless (lc($child->{data}{subreddit}) eq lc($ARGV{'-s'}));
    }
    if (exists $ARGV{'--lower'}) {
        next unless (score($child) < $ARGV{'--lower'});
    }
    if (exists $ARGV{'--upper'}) {
        next unless (score($child) > $ARGV{'--upper'});
    }
    if ($child->{kind} eq 't1') {           # comment
        if ($ARGV{'-b'}) {
            next unless ($child->{data}{body} =~ /$ARGV{'-b'}/o);
        }
    }

    if ($child->{kind} eq 't1') {           # comment
        print sprintf_reddit("%u  [%s]\n", $child);
        my $text = $child->{data}{body};
        if ($ARGV{'-b'}) {
            #while ($text =~ s/($ARGV{'-b'})/\e[91m$1\e[0m/gs) {
            $text =~ s/($ARGV{'-b'})/\e[91m$1\e[0m/gs;
        }
        $text = reddit_unescape($text);
        $text =~ s/^(>.*)/\e[90m$1\e[0m/gm;
        $text = word_wrap($text);
        $text =~ s/^/    /mg;
        print "$text\n\n";
    } else {
        #print ".\n";
    }
} 


sub score {
    my $json = shift;
    return ($json->{data}{ups} || 0) - ($json->{data}{downs} || 0);
}


sub reddit_unescape {
    my $text = shift;
    $text =~ s/&gt;/>/g;
    $text =~ s/&amp;/&/g;
    return $text;
}


sub word_wrap {
    my $string = shift;
    $string =~ s/(.{70}[^\s]*)\s+/$1\n/mg;
    return $string;
}


__DATA__
usage:   grep_comments.pl <username>  <options>

-b <regexp>
    a regular expression to use to search the body

-s <subreddit>
    a specific subreddit to focus on

--lower=<max score>
    Score must be below this.

--upper=<min score>
    Score must be above this.

--dump
    (development only)  Show how %ARGV is parsed.
