    $ ./fetch_all_comments.pl mayonesa
    (this takes a minute to run)
    ======== https://www.reddit.com/user/mayonesa/comments.json ========
            930 new entries                 
    ======== https://www.reddit.com/user/mayonesa/comments.json?sort=top ========
            971 new entries                 
    ======== https://www.reddit.com/user/mayonesa/comments.json?sort=controversial ========
            953 new entries                 
    ======== https://www.reddit.com/user/mayonesa/submitted.json ========
            996 new entries                 
    ======== https://www.reddit.com/user/mayonesa/submitted.json?sort=top ========
            979 new entries                 
    ======== https://www.reddit.com/user/mayonesa/submitted.json?sort=controversial ========
            931 new entries  

    $ ls *.json
    mayonesa.json

    $ ./flair.pl mayonesa.json 
       1120  new_right             
       667   pics                  
    #  537   Conservative          Paleoconservative
    #  438   Metal                 conservationist
       256   reddit.com            
       242   Republican            
       187   politics              
       159   MensRights            
       158   funny                 
       143   Libertarian           
       142   Foodforthought        
       126   WTF                   
    #  102   askaconservative      Monarchist
       100   lostgeneration        
       95    science               
       88    collapse              
       86    worldnews             
       72    philosophy            
       54    TheoryOfReddit        
       48    technology            
       41    monarchism            
       41    ImGoingToHellForThis  
       39    IAmA                  
       34    hipsters              
       34    tea_party             
       32    aww                   
       27    environment           
       26    MensRightsMeta        
       25    muhammedgonewild      
       24    overpopulation        
       22    worldpolitics         
       22    AskReddit             
       21    business              
       21    popping               
       20    gake                  
       18    ideasfortheadmins     
       17    houston               
       17    news                  
       17    Christianity          
       16    nihilism              
       16    Metalgate             
       14    cogsci                
       14    KotakuInAction        
       12    TwoXChromosomes       
       11    books                 
       10    programming           
       9     Liberal               
       9     2600                  
       9     SPLC                  
       9     MorbidReality         
       8     Music                 
       8     HBD                   
       7     nrx                   
       7     antiwork              
       7     TrueReddit            
       7     antisrs               
       7     Green                 
       7     SubredditDrama        
       6     OutOfTheLoop          
       6     conservatives         
       6     Israel                
       6     KiAChatroom           
       6     softscience           
       6     Anarchism             
       6     ShitRConservativeSays  
       5     conspiracy            
       5     eugenics              
       5     education             
       5     DepthHub              
       5     paleoconservative     
       5     atheism               
       5     occult 

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

    $ ./timezone.pl mayonesa.json 
    Hours are in UTC.
     0  ######################
     1  ###################################
     2  #################################################################
     3  ###################################################
     4  #########################
     5  #############
     6  ######
     7  ####
     8  ######
     9  #######
    10  #########
    11  #####################
    12  #######################################
    13  ###################################################################
    14  ###########################################################################
    15  ################################################################
    16  ######################################################################
    17  ###################################################################
    18  ############################################################
    19  ####################################################
    20  ##########################################
    21  #####################################################
    22  ################################################################
    23  ######################################

    Sun  ###########################################################################
    Mon  #########################################################################
    Tue  ###########################################################
    Wed  ###########################################################
    Thu  #######################################################################
    Fri  ############################################################
    Sat  ########################################################
