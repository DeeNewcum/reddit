#!/usr/bin/perl

# display the most common websites that are posted here

    use strict;
    use warnings;

    use JSON::XS;
    use URI;

    #use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements




my $subreddit = shift or die "specify a subreddit\n";
$subreddit =~ s/\.json$//s;


open my $fin, '<', "$subreddit.json"     or die $!;
my $json = decode_json( do {local $/=undef; <$fin>} );


my %domains;
foreach my $child (@{$json->{data}{children}}) {
    next if ($child->{data}{is_self} eq 'true');
    my $url = $child->{data}{url};
    my $domain = URI->new($url)->authority;

    # canonicalize the website somewhat
    $domain =~ s/^www\.//;
    $domain =~ s/^i\.(imgur\.com)$/$1/;

    print "$domain\n";
    $domains{$domain}++;
} 

my @domains = sort {$domains{$a} <=> $domains{$b}} keys %domains;
foreach my $domain (@domains) {
    printf "%5d  %s\n",
            $domains{$domain},
            "http://www.reddit.com/domain/$domain/";
}



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
