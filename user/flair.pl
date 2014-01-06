#!/usr/bin/perl

# display the list of subreddits they're active in, along with the flair in each one

    use strict;
    use warnings;

    use JSON::XS;

    #use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements




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

foreach my $sub (sort {$b->{count} <=> $a->{count}} values %subreddits) {
    next unless ($sub->{count} >= 5 || defined($sub->{flair}));
    printf "%s  %-4d  %-20s  %s\n",
            $sub->{flair} ? "#" : " ",
            $sub->{count},
            $sub->{name},
            $sub->{flair} || '';
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
