require_relative 'BBC.rb'

scanner = BBC.new

iplayer_total = scanner.getIplayerTotalVpids()

scanner.addHTMLheader()
scanner.printNewsVpids( "News - Front Page"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/front_page"   	)
scanner.printNewsVpids( "News - Most Popular"       , "http://trevor-producer.api.bbci.co.uk/content/most_popular/news" 	   	)
scanner.printNewsVpids( "News - Technology"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/technology" 	  )
scanner.printNewsVpids( "News - Politics"           , "http://trevor-producer.api.bbci.co.uk/content/cps/news/politics" 	    )
scanner.printNewsVpids( "News - Mundo Front Page"   , "http://trevor-producer.api.bbci.co.uk/content/cps/mundo/front_page" 	  )
scanner.printNewsVpids( "News - Russian Front Page" , "http://trevor-producer.api.bbci.co.uk/content/cps/russian/front_page"  )

scanner.printIplayerVpids( "iPlayer - Most Popular"  , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes"                                                 )
scanner.printIplayerVpids( "iPlayer - Not Very Popular" , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{(iplayer_total / 20) / 2}" )
scanner.printIplayerVpids( "iPlayer - Least Popular"    , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{iplayer_total / 20}"		   )

scanner.printIplayerTypeVpids( "iPlayer - Audio Described"  , "http://ibl.api.bbci.co.uk/ibl/v1/categories/audio-described/programmes" , "audio-described" )
scanner.printIplayerTypeVpids( "iPlayer - Signed"           , "http://ibl.api.bbci.co.uk/ibl/v1/categories/signed/programmes"          , "signed"          )

scanner.printIplayerChannelVpids( "iPlayer - Cbeebies"    , "https://ibl.api.bbci.co.uk/ibl/v1/channels/cbeebies/programmes"       )
scanner.printIplayerChannelVpids( "iPlayer - BBC Alba"    , "https://ibl.api.bbci.co.uk/ibl/v1/channels/bbc_alba/programmes"       )
scanner.printIplayerChannelVpids( "iPlayer - S4C"         , "https://ibl.api.bbci.co.uk/ibl/v1/channels/s4cpbs/programmes"         )

scanner.printAllPagesCombinedStats()
scanner.addHTMLSideLinks()
scanner.addHTMLFooter()
