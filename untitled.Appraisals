  






  def printIplayerTypeVpids( new_title , new_link , new_kind )
    index = 0
    temp_guidance = ""
    # Grab link and parse it
    website_resp = Net::HTTP.get_response(URI.parse(new_link))
    website_data = website_resp.body
    hash = JSON.parse(website_data)
    # Print iPlayer logo and header
    printIplayerHeader( new_title )
    # Cycle through the Hash and print info on each VPID
    hash["category_programmes"]["elements"].each do |parent|
      parent["initial_children"].each do |child|
        child["versions"].each do |version|
          if version["kind"] == new_kind
            background_image = assignBackgroundImage( parent["images"]["standard"] , index )
            @fileHtml.puts "<p>[#{index+=1}]</p>"
            @fileHtml.puts "<ul>"
            @fileHtml.puts "<li class='title'>#{parent["title"]}                                </li>"
            @fileHtml.puts "<li><hr>                                                            </li>"
            @fileHtml.puts " <li class='iplayer_vpid'>Vpid : #{version["id"]}                   </li>"
            @fileHtml.puts "<li><hr>                                                            </li>"
            @fileHtml.puts "<li class='iplayer_kind'>Kind : #{version["kind"]}                  </li>"
            @fileHtml.puts "<li class='iplayer_credit'>Credits : #{child["has_credits"]}        </li>"
            @fileHtml.puts "<li class='iplayer_hd'>HD : #{version["hd"]}                        </li>"
            @fileHtml.puts "<li class='iplayer_downl'>Download : #{version["download"]}         </li>"
            @fileHtml.puts "<li class='iplayer_durat'>Duration : #{version["duration"]["text"]} </li>"
            @fileHtml.puts "<li class='iplayer_guide'>Guidance : #{child["guidance"]}           </li>"
            # Guidance located at a different level in HASH
            if child["guidance"] == true and version["guidance"]
              temp_guidance = version["guidance"]["text"]["medium"]
              @fileHtml.puts "<li>Guidance : #{version["guidance"]["text"]["medium"]} </li>"
            end
            @fileHtml.puts "<li><hr></li>"
            # Store stats for summary
            @iplayer_stats[version["kind"]] += 1
            # Create links
            createIplayerLink( parent["id"] , version["kind"] )
            createCookBookLink( "iplayer" , background_image , parent["title"] , temp_guidance , version["id"] , "programme" )
            createTestCookBookLink( "iplayer" , background_image , parent["title"] , temp_guidance , version["id"] , "programme" )
            createAvailabilityToolLink ( version["id"] )
            createPipsLink(version["id"])
            # createPipsLink(parent["id"])
            # Display KIND flag
            createIplayerKindFlag( version["kind"] )
            @fileHtml.puts "</ul></div>"
          end
        end
      end
    end
  end
