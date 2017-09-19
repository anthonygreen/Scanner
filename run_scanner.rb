# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Author : william.daly@bbc.co.uk
# Desc   : This is the file you execute to initialise Scanner and for it to grab + print content
#          It only takes a few seconds to complete
#          Once complete this script will generate "index.html"
#          If you want to add more content to be scanned + printed then view comments below!
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

require_relative 'Scanner.rb'
scanner = Scanner.new
iplayer_total = scanner.getIplayerTotalVpids()

scanner.addHTMLheader()

scanner.printNewsVpidsFromLink( "News - Front Page"			, "http://trevor-producer.api.bbci.co.uk/content/cps/news/front_page"    )
scanner.printNewsVpidsFromLink( "News - Most Popular"       , "http://trevor-producer.api.bbci.co.uk/content/most_popular/news" 	 )
scanner.printNewsVpidsFromLink( "News - Technology"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/technology" 	 )
scanner.printNewsVpidsFromLink( "News - Politics"           , "http://trevor-producer.api.bbci.co.uk/content/cps/news/politics" 	 )
scanner.printNewsVpidsFromLink( "News - Mundo Front Page"   , "http://trevor-producer.api.bbci.co.uk/content/cps/mundo/front_page" 	 )
scanner.printNewsVpidsFromLink( "News - Russian Front Page" , "http://trevor-producer.api.bbci.co.uk/content/cps/russian/front_page" )

scanner.printIplayerVpidsFromLink( "iPlayer - Most Popular"     , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes" , "group_episodes" , ""   )
scanner.printIplayerVpidsFromLink( "iPlayer - Not Very Popular" , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{(iplayer_total / 20) / 2}" , "group_episodes" , "" )
scanner.printIplayerVpidsFromLink( "iPlayer - Least Popular"    , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{iplayer_total / 20}"       , "group_episodes" , "" )
scanner.printIplayerVpidsFromLink( "iPlayer - Guidance"         , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes" , "group_episodes" , "guidance"   )

# Other below options could include anything under the "Categories" dropdown on IBL
scanner.printIplayerVpidsFromLink( "iPlayer - Audio Described" , "http://ibl.api.bbci.co.uk/ibl/v1/categories/audio-described/programmes" , "category_programmes" , "audio-described"  )
scanner.printIplayerVpidsFromLink( "iPlayer - Signed"          , "http://ibl.api.bbci.co.uk/ibl/v1/categories/signed/programmes"          , "category_programmes"  , "signed" )

# Other below options could include anything under the "Channels" dropdown on IBL
scanner.printIplayerVpidsFromLink( "iPlayer - Cbeebies" , "https://ibl.api.bbci.co.uk/ibl/v1/channels/cbeebies/programmes" , "channel_programmes"    , "" )
scanner.printIplayerVpidsFromLink( "iPlayer - S4C"      , "https://ibl.api.bbci.co.uk/ibl/v1/channels/s4cpbs/programmes"   , "channel_programmes"    , "" )

scanner.printAllPagesCombinedStats()
scanner.addNavBarLinks()
scanner.addHTMLFooter()