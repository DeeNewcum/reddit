#!/usr/bin/perl

# Display the list of subreddits they're active in, along with the flair in each one.
#
# Example:
#
#    $ ./fetch_all_comments.pl TheCommieDuck
#
#    $ ./flair.pl TheCommieDuck.json | grep ^#
#    #  887   tf2trade              http://steamcommunity.com/profiles/76561198034183306
#    #  115   SteamGameSwap         http://steamcommunity.com/profiles/76561198034183306
#    #  46    unitedkingdom         Wiltshire
#    #  43    Steam                 Princess Flutterslut
#    #  43    SteamTradingCards     TheCommieDuck
#    #  14    GlobalOffensiveTrade  http://steamcommunity.com/profiles/76561198034183306
#    #  9     europe                United Kingdom
#    #  8     paradoxplaza          Map Staring Expert
#    #  7     patientgamers         QUBE, Brutal Legend.
#    #  5     playitforward         7 - 1
#    #  5     pokemontrades         4828-4413-2266
#    #  4     ACTrade               4828-4413-2266 | Flutter, Cat-Town
#    #  3     MLPLounge             Fluttershy
#    #  3     Music                 TheCommieDuck
#    #  3     skyrim                flair
#    #  3     footballmanagergames  Karlstad
#    #  2     polandball            British Empire
#    #  2     dogemarket            1/8/2
#    #  2     catpictures           Meow!
#    #  2     CasualPokemonTrades   Fluttersloot 4828-4413-2266
#    #  1     creepyPMs             (◕‿◕✿)
#    #  1     LucidDreaming         Attempting to start learning
#    #  1     Diablo                CommieDuck


    use strict;
    use warnings;

    use JSON::XS;

    #use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements


binmode(STDOUT, ":utf8");           # SENDS UTF8 TO STDOUT


my $username = shift or die "specify a username\n";
$username =~ s/\.json$//s;


open my $fin, '<', "$username.json"     or die $!;
my $json = decode_json( do {local $/=undef; <$fin>} );


my %subreddits;      # value is:
        #   { count => 0,
        #     flair => '')
foreach my $child (@{$json->{data}{children}}) {
    my $subname = $child->{data}{subreddit};
    $subreddits{$subname} ||= {name => $subname};
    my $sub = $subreddits{$subname};

    $sub->{count}++;
    $sub->{flair} = $child->{data}{author_flair_text}
            if defined($child->{data}{author_flair_text});
} 

print "        #posts subreddit               flair\n";
print "        ------ ----------------------- -------------------\n";
my @subreddits_ordered = sort {$b->{count} <=> $a->{count}} values %subreddits;
foreach my $sub (@subreddits_ordered) {
    next unless ($sub->{count} >= 5 || defined($sub->{flair}));
    printf "        %-4d  /r/%-20s  %s\n",
            $sub->{count},
            $sub->{name},
            $sub->{flair} || '';
}

## Print out the top 5 subreddits, which I use for /r/ProfileSummary.
my @top_5 = splice(@subreddits_ordered, 0, 5);
print "\n* Your top ", scalar(@top_5), " subreddits by post count are -- ";
foreach (my $ctr=0; $ctr<@top_5; $ctr++) {
    if ($ctr == @top_5 - 1) {
        print "and ";
    }
    print "/r\\/", $top_5[$ctr]{name};
    if ($ctr < @top_5 - 1) {
        print ", ";
    }
}
print ".\n";


# given a chunk of JSON, print the URL that poitns to that
sub reddit_url {
    my $json = shift;
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
