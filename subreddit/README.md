This tool is used to find info about common posters and common websites in any subreddit.

    $ ./fetch_all_links.pl WhiteRights
    (takes a minute, be patient)
    
    $ ls *.json
    WhiteRights.json
    
    $ ./common_websites.pl WhiteRights.json  | tail
       14  http://www.reddit.com/domain/vdare.com/
       15  http://www.reddit.com/domain/counter-currents.com/
       17  http://www.reddit.com/domain/thelocal.se/
       21  http://www.reddit.com/domain/theoccidentalobserver.net/
       30  http://www.reddit.com/domain/dailystormer.com/
       34  http://www.reddit.com/domain/dailymail.co.uk/
       35  http://www.reddit.com/domain/reddit.com/
       43  http://www.reddit.com/domain/whitegenocideproject.com/
       71  http://www.reddit.com/domain/imgur.com/
       83  http://www.reddit.com/domain/youtube.com/
    
    $ ./common_posters.pl WhiteRights.json  | tail
       27  http://www.reddit.com/user/This-Is-My-Truth/
       35  http://www.reddit.com/user/Die_Endlosung/
       36  http://www.reddit.com/user/Gas-the-Kikes/
       44  http://www.reddit.com/user/STOP-RACIST-MEDIA/
       45  http://www.reddit.com/user/Proud_European/
       52  http://www.reddit.com/user/starpnt/
       55  http://www.reddit.com/user/Wake_Up_White_Man/
       70  http://www.reddit.com/user/Le_Cancer-kin/
      174  http://www.reddit.com/user/slippery_people/
      229  http://www.reddit.com/user/bumblingmumbling/
