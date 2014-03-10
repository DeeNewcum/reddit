    $ ./fetch_all_comments.pl mayonesa
    (this takes a minute to run...)

    $ ls *.json
    mayonesa.json

    $ ./flair.pl mayonesa.json 
       455   new_right             
       381   sodom                 
    #  189   Conservative          Paleoconservative
       142   conservatism          
       68    pics                  
       66    askaconservative      
       61    WTF                   
       60    tea_party             
       53    Republican            
       46    Anarcho_Capitalism    
    #  42    ShitRConservativeSays  Making a valient effot at common decency 
       34    alternative_right     
       31    TrueChristian         
       27    Foodforthought        
       24    race                  
       23    TheRedPill            
       19    politics              
       19    HBD                   
       19    peasants              
       16    traditionalist        
       15    science               
       12    lostgeneration        
       12    collapse              
       11    MensRights            
       10    accountt1234          
       9     nationalist           
       9     popping               
       8     Libertarian           
       7     funny                 
       7     MANPOETRY             
       6     antifa                
       5     immigration           
       5     falseracism           
 
    $ ./grep_comments.pl 
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

    $ ./grep_comments.pl mayonesa.json -s sodom
