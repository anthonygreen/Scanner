require_relative 'BBC.rb'

new_bbc_site = BBC.new

iplayer_total = new_bbc_site.getIplayerTotalVpids()

new_bbc_site.addHTMLheader()
new_bbc_site.getAndPrint( "NEWS" , "News - Front Page"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/front_page" 	)
new_bbc_site.getAndPrint( "NEWS" , "News - Most Popular"       , "http://trevor-producer.api.bbci.co.uk/content/most_popular/news" 		)
new_bbc_site.getAndPrint( "NEWS" , "News - Technology"         , "http://trevor-producer.api.bbci.co.uk/content/cps/news/technology" 	)
new_bbc_site.getAndPrint( "NEWS" , "News - Politics"           , "http://trevor-producer.api.bbci.co.uk/content/cps/news/politics" 	    )
new_bbc_site.getAndPrint( "NEWS" , "News - Business"           , "http://trevor-producer.api.bbci.co.uk/content/cps/news/business" 	    )
new_bbc_site.getAndPrint( "NEWS" , "News - Mundo Front Page"   , "http://trevor-producer.api.bbci.co.uk/content/cps/mundo/front_page" 	)
new_bbc_site.getAndPrint( "NEWS" , "News - Russian Front Page" , "http://trevor-producer.api.bbci.co.uk/content/cps/russian/front_page" )
new_bbc_site.getAndPrint( "IPLAYER" , "iPlayer - Most Popular"     , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes"                     )
new_bbc_site.getAndPrint( "IPLAYER" , "iPlayer - Somewhat Popular" , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=5"  )
new_bbc_site.getAndPrint( "IPLAYER" , "iPlayer - Not Very Popular" , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{(iplayer_total / 20) / 2}" )
new_bbc_site.getAndPrint( "IPLAYER" , "iPlayer - Least Popular"    , "https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=20&page=#{iplayer_total / 20}"		  )
new_bbc_site.printAllPagesCombinedStats()
new_bbc_site.addHTMLSideLinks()
new_bbc_site.addHTMLFooter()
