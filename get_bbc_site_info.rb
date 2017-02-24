require_relative 'BBC.rb'

new_bbc_site = BBC.new

iplayer_total = new_bbc_site.getIplayerTotalVpids()

new_bbc_site.addHTMLheader()
new_bbc_site.printNewsVpids( "News - Front Page"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/front_page"   	)
new_bbc_site.printNewsVpids( "News - Most Popular"       , "http://trevor-producer.api.bbci.co.uk/content/most_popular/news" 	   	)
new_bbc_site.printNewsVpids( "News - Technology"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/technology" 	  )
new_bbc_site.printNewsVpids( "News - Politics"           , "http://trevor-producer.api.bbci.co.uk/content/cps/news/politics" 	    )
new_bbc_site.printNewsVpids( "News - Business"           , "http://trevor-producer.api.bbci.co.uk/content/cps/news/business" 	    )
new_bbc_site.printNewsVpids( "News - Mundo Front Page"   , "http://trevor-producer.api.bbci.co.uk/content/cps/mundo/front_page" 	)
new_bbc_site.printNewsVpids( "News - Russian Front Page" , "http://trevor-producer.api.bbci.co.uk/content/cps/russian/front_page" )

new_bbc_site.printIplayerVpids( "iPlayer - Most Popular"  , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes"                                                 )
new_bbc_site.printIplayerVpids( "iPlayer - Somewhat Popular" , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=5"                           )
new_bbc_site.printIplayerVpids( "iPlayer - Not Very Popular" , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{(iplayer_total / 20) / 2}" )
new_bbc_site.printIplayerVpids( "iPlayer - Least Popular"    , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{iplayer_total / 20}"		    )

new_bbc_site.printIplayerTypeVpids( "iPlayer - Audio Described"  , "http://ibl.api.bbci.co.uk/ibl/v1/categories/audio-described/programmes" , "audio-described"         )
new_bbc_site.printIplayerTypeVpids( "iPlayer - Signed"           , "http://ibl.api.bbci.co.uk/ibl/v1/categories/signed/programmes"          , "signed"                  )

new_bbc_site.printIplayerChannelVpids( "iPlayer - BBC Radio 1" , "https://ibl.api.bbci.co.uk/ibl/v1/channels/bbc_radio_one/programmes")
new_bbc_site.printIplayerChannelVpids( "iPlayer - Cbeebies"    , "https://ibl.api.bbci.co.uk/ibl/v1/channels/cbeebies/programmes")
new_bbc_site.printIplayerChannelVpids( "iPlayer - CBBC"        , "https://ibl.api.bbci.co.uk/ibl/v1/channels/cbbc/programmes")

new_bbc_site.printAllPagesCombinedStats()
new_bbc_site.addHTMLSideLinks()
new_bbc_site.addHTMLFooter()
