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

# More News content can be found at https://confluence.dev.bbc.co.uk/display/~jamie.pitts@bbc.co.uk/Trevor+Example+Endpoints
# However I chose this links as they are not stale
scanner.printNewsVpidsFromLink( "News - Front Page"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/front_page"    )
# scanner.printNewsVpids( "News - Most Popular"       , "http://trevor-producer.api.bbci.co.uk/content/most_popular/news" 	 )
# scanner.printNewsVpids( "News - Technology"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/technology" 	 )
# scanner.printNewsVpids( "News - Politics"           , "http://trevor-producer.api.bbci.co.uk/content/cps/news/politics" 	 )
# scanner.printNewsVpids( "News - Mundo Front Page"   , "http://trevor-producer.api.bbci.co.uk/content/cps/mundo/front_page" 	 )
# scanner.printNewsVpids( "News - Russian Front Page" , "http://trevor-producer.api.bbci.co.uk/content/cps/russian/front_page" )

# More iPlayer content can be found at https://inspector.ibl.api.bbci.co.uk/
scanner.printIplayerVpidsFromLink( "iPlayer - Most Popular"     , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes" , "group_episodes" , "versions" )
# scanner.printIplayerVpids( "iPlayer - Not Very Popular" , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{(iplayer_total / 20) / 2}" )
# scanner.printIplayerVpids( "iPlayer - Least Popular"    , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{iplayer_total / 20}"       )
# scanner.printGuidanceIplayerVpids( "iPlayer - Guidance" , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=40&page=1" )

# # Other below options could include anything under the "Categories" dropdown on IBL
# # E.G http://ibl.api.bbci.co.uk/ibl/v1/categories/films/programmes
# scanner.printIplayerTypeVpids( "iPlayer - Audio Described" , "http://ibl.api.bbci.co.uk/ibl/v1/categories/audio-described/programmes" , "audio-described" )
# # scanner.printIplayerTypeVpids( "iPlayer - Signed"          , "http://ibl.api.bbci.co.uk/ibl/v1/categories/signed/programmes"          , "signed"          )

# # Other below options could include anything under the "Channels" dropdown on IBL
# # E.G https://ibl.api.bbci.co.uk/ibl/v1/channels/bbc_one_london/programmes
# scanner.printIplayerChannelVpids( "iPlayer - Cbeebies" , "https://ibl.api.bbci.co.uk/ibl/v1/channels/cbeebies/programmes" )
# scanner.printIplayerChannelVpids( "iPlayer - BBC Alba" , "https://ibl.api.bbci.co.uk/ibl/v1/channels/bbc_alba/programmes" )
# scanner.printIplayerChannelVpids( "iPlayer - S4C"      , "https://ibl.api.bbci.co.uk/ibl/v1/channels/s4cpbs/programmes"   )

scanner.printAllPagesCombinedStats()
scanner.addNavBarLinks()
scanner.addHTMLFooter()
