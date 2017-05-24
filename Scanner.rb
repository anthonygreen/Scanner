# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Author : william.daly@bbc.co.uk
# Desc   : This is the file where all the magic happens!
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require "net/http"
require "uri"
require "json"
require 'base64'
require 'time'

class Scanner

  #---------------------------------------------------------------------------------

  def initialize()
    @side_links, @iplayer_stats, @news_stats = [] , Hash.new(0), Hash.new(0)
  end

  #---------------------------------------------------------------------------------

  def addHTMLheader()
    @fileHtml = File.new("derp.html", "w+")
    t = Time.now
    @fileHtml.puts '
    <html>
      <head>
        <title>BBC Scanner</title>
        <link rel="stylesheet" type="text/css" href="index.css"/>
        <meta charset="UTF-8">
      </head>
      <div id="nav_bar">
        <h1><a href="#"><img id="bbc_logo" src="images/bbc_logo.jpeg"/> Scanner</a></h1>
      </div>
      <div id="wrapper">
        <p>Welcome!</p>
        <p>Scanner outputs current video + audio vpids on iPlayer and News!</p>
        <p>Data is loaded + filtered from
        <a href="https://confluence.dev.bbc.co.uk/display/~jamie.pitts@bbc.co.uk/Trevor+Example+Endpoints" target="_blank">TREVOR</a>
        and
        <a href="https://inspector.ibl.api.bbci.co.uk" target="_blank">IBL</a></p>
        <p>Any queries please contact <b>william.daly@bbc.co.uk</b></p>'
        @fileHtml.puts "<p>Latest scan took place at - <div id='scan_time'>#{Time.now.strftime("%A %e  %B %Y at %l:%M %p")}</div></p>"
  end

  #---------------------------------------------------------------------------------

  def addNavBarLinks()
    @fileHtml.puts "
    <div>
      <div id='links'>
          <p>Available links</p>
          <ul>"
    @side_links.each do |heading|
    @fileHtml.puts "<li><a href='##{heading.delete(' ')}'>#{heading}</a></li>"
    end
    @fileHtml.puts "</ul></div></div>"
  end

  #---------------------------------------------------------------------------------

  def addHTMLFooter()
    @fileHtml.puts '</body></html>'
  end

  #---------------------------------------------------------------------------------

  def printAllPagesCombinedStats()
    @fileHtml.puts '<div id="stats_summary">'
    @fileHtml.puts "<p>Scanner has detected <b>right now</b> there are vpids with properties -</p>"
    printNewsStats()
    printIplayerStats()
    @fileHtml.puts "</div>"
  end

  #---------------------------------------------------------------------------------

  def printIplayerStats()
    @fileHtml.puts '<div id="iplayer_summary">'
    @fileHtml.puts "<h3>Iplayer</h3>"
    @fileHtml.puts "<ul>"
    @iplayer_stats = Hash[@iplayer_stats.map {|k,v| [k,v.to_s] }]
    # Sort list alphabetically so it'll be easier to read in the final HTML output
    temp = Hash[ @iplayer_stats.sort_by { |key, val| key } ]
    temp.each do |key,value|
    @fileHtml.puts "<li class='stat'>#{key} = #{value}</li>"
    end
    @fileHtml.puts "</ul>"
    @fileHtml.puts "</div>"
  end

  #---------------------------------------------------------------------------------

  def printNewsStats()
    @fileHtml.puts '<div id="news_summary">'
    @fileHtml.puts "<h3>News</h3>"
    @fileHtml.puts "<ul>"
    @news_stats = Hash[@news_stats.map {|k,v| [k,v.to_s] }]
    # Sort it alphabetically so it'll be easier to read in the final HTML output
    temp = Hash[ @news_stats.sort_by { |key, val| key } ]
    temp.each do |key,value|
      if key != ""
        @fileHtml.puts "<li class='stat'>#{key} = #{value}</li>"
      end
    end
    @fileHtml.puts "</ul></div>"
  end

  #---------------------------------------------------------------------------------

  def printNewsHeader( new_title )
    @fileHtml.puts "<div id='#{new_title.delete(' ')}'>"
    @fileHtml.puts "<h2><img id='image_#{new_title.delete(' ')}'src='images/news_icon.jpeg'/> #{new_title}</h2>"
    @side_links.push("#{new_title}")
  end

  #---------------------------------------------------------------------------------

  def printIplayerHeader( new_title )
    @fileHtml.puts "<div id='#{new_title.delete(' ')}'>"
    @fileHtml.puts "<h2><img id='image_#{new_title.delete(' ')}'src='images/iplayer_icon.jpeg'/> #{new_title}</h2>"
    @side_links.push("#{new_title}")
  end

  #---------------------------------------------------------------------------------

  def getIplayerTotalVpids()
    @website_resp = Net::HTTP.get_response(URI.parse("https://ibl.api.bbci.co.uk/ibl/v1/groups/popular/episodes?per_page=1&page=1"))
    @website_data = @website_resp.body
    @hash = JSON.parse(@website_data)
    return @hash["group_episodes"]["count"]
  end

  #---------------------------------------------------------------------------------

  def createIplayerLink( new_parent_id , new_kind )
    tag = ''
    if new_kind == "audio-described"
      tag = 'ad'
    elsif new_kind == "signed"
      tag = 'sign'
    end
    @fileHtml.puts "<li class='iplayer_link'><a href='http://www.bbc.co.uk/iplayer/episode/#{new_parent_id}/#{tag}'
    target='_blank'>iPlayer Link</a></li>"
  end

  #---------------------------------------------------------------------------------

  def createIplayerKindFlag( new_kind )
    if new_kind == "audio-described"
      @fileHtml.puts "<li class='iplayer_kind_flag_ad'>AD</li>"
    elsif new_kind == "signed"
      @fileHtml.puts "<li class='iplayer_kind_flag_sl'>SIGN</li>"
    end
  end

  #---------------------------------------------------------------------------------

  def createNewsArticleLink( new_parent_id )
    # E.g /cps/news/uk-england-lancashire-39869308 GOES TO http://www.bbc.co.uk/news/uk-england-lancashire-39869308
    @fileHtml.puts "<li class='news_link'><a href='#{new_parent_id.sub( "/cps" , "http://www.bbc.co.uk")}'
    target='_blank'>News Article Link</a></li>"
  end

  #---------------------------------------------------------------------------------

  def createPipsLink( new_pid )
    @fileHtml.puts "<li class='pips_link'><a href='https://api.live.bbc.co.uk/pips/inspector/pip/#{new_pid}' target='_blank'>Pips Link</a></li>"
  end

  #---------------------------------------------------------------------------------

  def createAvailabilityToolLink( new_pid )
     @fileHtml.puts "<li class='avail_link'><a href='http://media-availability.tools.bbc.co.uk/#{new_pid}?
     mediator=http%3A%2F%2Fopen.live.bbc.co.uk' target='_blank'>Availability Link</a></li>"
  end

  #---------------------------------------------------------------------------------

  def createCookBookLink( new_product , new_holding_image , new_title , new_guidance , new_vpid , new_kind )
    smp_settings =
    {
      'product' => new_product,
      'superResponsive' => true
    }

    smp_playlist =
    {
      'holdingImageURL' => new_holding_image,
      'title'           => new_title,
      'guidance'        => new_guidance,
      'items' =>
      [
        {
          'versionID' => new_vpid,
          'kind'      => new_kind
        }
      ]
    }
    # Need to encode settings object + playlist object so they can be passed via browser to the COOKBOOK page successfully!
    encoded_settings = Base64.encode64(smp_settings.to_json).gsub("\n", '')
    encoded_playlist = Base64.encode64(smp_playlist.to_json).gsub("\n", '')
    @fileHtml.puts "<li class='cookbook_link'><a href='http://cookbook.tools.bbc.co.uk/#{new_product}?settings=#{encoded_settings}&playlist=#{encoded_playlist}'target='_blank'>Push To Cookbook</a></li>"
  end

  #---------------------------------------------------------------------------------

  def collectCurrentNewsEntryStats( new_version )
    # These are the only real interesting stats for NEWS content I want
    @news_stats["#{new_version["content"]["guidance"]}"] += 1
    @news_stats["Embeddable #{new_version["content"]["isEmbeddable"]}"] += 1
  end

  #---------------------------------------------------------------------------------

  def assignBackgroundImage( new_ichef_url , new_index )
    # If NEWS ichef URL, e.g - http://ichef.bbci.co.uk/images/ic/$recipe/p04l3rkg.jpg
    if new_ichef_url =~ /\$recipe/
      holding_image = "#{new_ichef_url.sub("$recipe", "976x549")}"
      puts "News -> #{holding_image}"
      @fileHtml.puts "<div id='entry_#{new_index}' class='entry_style' style='background-image:
      linear-gradient(rgba(255,255,255,0.8),rgba(255,255,255,1.0)),url(#{holding_image})'>"

    # Else If IPLAYER ichef URL, e.g - https://ichef.bbci.co.uk/images/ic/{recipe}/p04swgkh.jpg
    elsif new_ichef_url =~ /{recipe}/i
      holding_image = "#{new_ichef_url.sub("{recipe}", "976x549")}"
      puts "iPlayer -> #{holding_image}"
      @fileHtml.puts "<div id='entry_#{new_index}' class='entry_style' style='background-image:
      linear-gradient(rgba(255,255,255,0.8),rgba(255,255,255,1.0)),url(#{holding_image})'>"

    # Else there's no image
    else
      @fileHtml.puts "<div id='entry_#{new_index}' class='entry_style' style='background-image:
      linear-gradient(rgba(255,255,255,0.8),rgba(255,255,255,1.0)),url(#{holding_image})'>"
    end

    return holding_image
  end

  #---------------------------------------------------------------------------------

  def printNewsVpids( new_title , new_link )
    index = 0
    external_trevor_links = []
    entry_vpids = []
    # Grab link and parse it
    website_resp = Net::HTTP.get_response(URI.parse(new_link))
    website_data = website_resp.body
    hash = JSON.parse(website_data)
    # Print News logo and header
    printNewsHeader( new_title )
    # Cycle through the Hash and print info on each VPID
    hash["relations"].each do |parent|
      parent["content"]["relations"].each do |version|
        # Make a link from parent vpid, we may have to use in search of AUDIO
        parent_link = "http://trevor-producer.api.bbci.co.uk/content#{parent["content"]["id"]}"
        # IF the current entry has an externalID (vpid) simply print it out and its info to the HTML page
        if version["content"]["externalId"] and not entry_vpids.include? version["content"]["externalId"]
          entry_vpids.push( version["content"]["externalId"] )
          index += 1
          printSingleNewsEntryInfo( index , parent["content"]["id"] , version )
        # Else if there is NO externalId and we haven't used the link before then we visit it to check external Trevor links for AUDIO vpids!
        elsif not version["content"]["externalId"] and not external_trevor_links.include? parent_link
          # Grab link and parse it
          @website_resp = Net::HTTP.get_response(URI.parse(parent_link))
          @website_data = @website_resp.body
          temp_hash = JSON.parse(@website_data)
          # Store current link so we don't revisit the same TREVOR link multiple times
          external_trevor_links.push(parent_link)
          # This loop is for AUDIO since its stored differently in TREVOR
          temp_hash["relations"].each do |audio_hash|
            # If its an audio vpid, a vpid we haven't pushed before AND duration is greater than 0 (not a stream!) then grab it!
            if audio_hash["content"]["externalId"] and not entry_vpids.include? audio_hash["content"]["externalId"] and audio_hash["content"]["duration"] > 1
              entry_vpids.push( audio_hash["content"]["externalId"] )
              index += 1
              printSingleNewsEntryInfo( index , parent["content"]["id"] , audio_hash )
            end
          end
        end
      end
    end
    # This div is to close all the News entries before moving onto iPlayer
    @fileHtml.puts "</div>"
  end

  #---------------------------------------------------------------------------------

  def printSingleNewsEntryInfo( new_index , new_parent , new_version )
    collectCurrentNewsEntryStats( new_version )
    background_image = assignBackgroundImage( new_version["content"]["iChefUrl"] , new_index )

    @fileHtml.puts "<p>[#{new_index}]</p>"
    @fileHtml.puts "<ul>"
    @fileHtml.puts "<li class='caption'> #{new_version["content"]["caption"]}                                       </li>"
    @fileHtml.puts "<li><hr></li>"
    @fileHtml.puts " <li class='news_vpid'>Vpid : #{new_version["content"]["externalId"]}                           </li>"
    @fileHtml.puts "<li><hr>                                                                                        </li>"
    @fileHtml.puts "<li class='news_type' >Type : #{new_version["content"]["type"].sub( "bbc.mobile.news." , "")}   </li>"
    @fileHtml.puts "<li class='news_embed'>Embeddable : #{new_version["content"]["isEmbeddable"]}                   </li>"
    @fileHtml.puts "<li class='news_avail'>Available : #{new_version["content"]["isAvailable"]}                     </li>"
    @fileHtml.puts "<li class='news_durat'>Duration :  #{new_version["content"]["duration"]/1000} secs              </li>"
    @fileHtml.puts "<li class='news_guide'>Guidance : #{new_version["content"]["guidance"]}</li>" if new_version["content"]["guidance"]
    @fileHtml.puts "<li><hr></li>"

    createNewsArticleLink( new_parent )

    if new_version["content"]["type"] == "bbc.mobile.news.audio"
      createCookBookLink( "news" , background_image , new_version["content"]["caption"] , new_version["content"]["guidance"] , new_version["content"]["externalId"] , "radioProgramme" )
    else
      createCookBookLink( "news" , background_image , new_version["content"]["caption"] , new_version["content"]["guidance"] , new_version["content"]["externalId"] , "programme" )
    end

    createAvailabilityToolLink( new_version["content"]["externalId"] )
    createPipsLink( new_version["content"]["externalId"] )
    @fileHtml.puts "<li class='news_audio_flag'>AUDIO</li>" if new_version["content"]["type"] == "bbc.mobile.news.audio"
    @fileHtml.puts "</ul></div>"
  end

  #---------------------------------------------------------------------------------

  def printIplayerVpids( new_title , new_link )
    index = 0
    temp_guidance = ""
    # Grab link and parse it
    website_resp = Net::HTTP.get_response(URI.parse(new_link))
    website_data = website_resp.body
    hash = JSON.parse(website_data)
    # Print iPlayer logo and header
    printIplayerHeader( new_title )
    # Cycle through the Hash and print info on each VPID
    hash["group_episodes"]["elements"].each do |parent|
      parent["versions"].each do |version|
        background_image = assignBackgroundImage( parent["images"]["standard"] , index )
        @fileHtml.puts "<p>[#{index+=1}]</p>"
        @fileHtml.puts "<ul>"
        @fileHtml.puts "<li class='title'>#{parent["title"]}                                </li>"
        @fileHtml.puts "<li><hr>                                                            </li>"
        @fileHtml.puts " <li class='iplayer_vpid'>Vpid : #{version["id"]}                   </li>"
        @fileHtml.puts "<li><hr>                                                            </li>"
        @fileHtml.puts "<li class='iplayer_kind'>Kind : #{version["kind"]}                  </li>"
        @fileHtml.puts "<li class='iplayer_credit'>Credits : #{parent["has_credits"]}       </li>"
        @fileHtml.puts "<li class='iplayer_hd'>HD : #{version["hd"]}                        </li>"
        @fileHtml.puts "<li class='iplayer_downl'>Download : #{version["download"]}         </li>"
        @fileHtml.puts "<li class='iplayer_durat'>Duration : #{version["duration"]["text"]} </li>"
        @fileHtml.puts "<li class='iplayer_guide'>Guidance : #{parent["guidance"]}          </li>"
        # There's a bug in IBL where a VPID may not display guidance despite its PARENT saying it does!
        if parent["guidance"] == true and version["guidance"]
          temp_guidance = version["guidance"]["text"]["medium"]
          @fileHtml.puts "<li>Guidance : #{version["guidance"]["text"]["medium"]}           </li>"
        end
        @fileHtml.puts "<li><hr></li>"
        # Store stats for summary
        @iplayer_stats[version["kind"]] += 1
        # Create links
        createIplayerLink( parent["id"] , version["kind"] )
        createCookBookLink( "iplayer" , background_image , parent["title"] , temp_guidance , version["id"] , "programme" )
        createAvailabilityToolLink ( version["id"] )
        createPipsLink(version["id"])
        # createPipsLink(parent["id"])
        # Display KIND flag
        createIplayerKindFlag( version["kind"] )
        @fileHtml.puts "</ul></div>"
      end
    end
  end

  #---------------------------------------------------------------------------------

  def printGuidanceIplayerVpids( new_title , new_link )
    index = 0
    temp_guidance = ""
    # Grab link and parse it
    website_resp = Net::HTTP.get_response(URI.parse(new_link))
    website_data = website_resp.body
    hash = JSON.parse(website_data)
    # Print iPlayer logo and header
    printIplayerHeader( new_title )
    # Cycle through the Hash and print info on each VPID
    hash["group_episodes"]["elements"].each do |parent|
      parent["versions"].each do |version|
        if parent["guidance"] == true
          background_image = assignBackgroundImage( parent["images"]["standard"] , index )
          @fileHtml.puts "<p>[#{index+=1}]</p>"
          @fileHtml.puts "<ul>"
          @fileHtml.puts "<li class='title'>#{parent["title"]}                                </li>"
          @fileHtml.puts "<li><hr>                                                            </li>"
          @fileHtml.puts " <li class='iplayer_vpid'>Vpid : #{version["id"]}                   </li>"
          @fileHtml.puts "<li><hr>                                                            </li>"
          @fileHtml.puts "<li class='iplayer_kind'>Kind : #{version["kind"]}                  </li>"
          @fileHtml.puts "<li class='iplayer_credit'>Credits : #{parent["has_credits"]}       </li>"
          @fileHtml.puts "<li class='iplayer_hd'>HD : #{version["hd"]}                        </li>"
          @fileHtml.puts "<li class='iplayer_downl'>Download : #{version["download"]}         </li>"
          @fileHtml.puts "<li class='iplayer_durat'>Duration : #{version["duration"]["text"]} </li>"
          @fileHtml.puts "<li class='iplayer_guide'>Guidance : #{parent["guidance"]}          </li>"
          # There's a bug in IBL where a VPID may not display guidance despite its PARENT saying it does!
          if parent["guidance"] == true and version["guidance"]
            temp_guidance = version["guidance"]["text"]["medium"]
            @fileHtml.puts "<li>Guidance : #{version["guidance"]["text"]["medium"]}           </li>"
          end
          @fileHtml.puts "<li><hr></li>"
          # Store stats for summary
          @iplayer_stats[version["kind"]] += 1
          # Create links
          createIplayerLink( parent["id"] , version["kind"] )
          createCookBookLink( "iplayer" , background_image , parent["title"] , temp_guidance , version["id"] , "programme" )
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

  # #---------------------------------------------------------------------------------

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

  #---------------------------------------------------------------------------------

  def printIplayerChannelVpids( new_title , new_link )
    index = 0
    temp_guidance = ""
    # Grab link and parse it
    website_resp = Net::HTTP.get_response(URI.parse(new_link))
    website_data = website_resp.body
    hash = JSON.parse(website_data)
    # Print iPlayer logo and header
    printIplayerHeader( new_title )
    # Cycle through the Hash and print info on each VPID
    hash["channel_programmes"]["elements"].each do |parent|
      parent["initial_children"].each do |child|
        child["versions"].each do |version|
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

  #---------------------------------------------------------------------------------

end
