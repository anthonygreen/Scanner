require "net/http"
require "uri"
require "json"
require 'base64'
require 'time'

class BBC

  def initialize()
    @website_resp, @website_data, @hash, @side_links = "", "", "", []
  end

  #---------------------------------------------------------------------------------

  def addHTMLheader()
    @fileHtml = File.new("daly_bbc_scanner.html", "w+")
    t = Time.now
    @fileHtml.puts '
    <html>
      <head>
        <title>BBC Scanner</title>
        <link rel="stylesheet" type="text/css" href="bbc_site_summary.css"/>
        <meta charset="UTF-8">
      </head>
      <div id="nav_bar">
        <h1><a href="#"><img id="bbc_logo" src="images/bbc_logo.jpeg"/> Scanner</a></h1>
      </div>
      <div id="wrapper">
        <p>Welcome!</p>
        <p>BBC Scanner outputs the current video and audio catalogue of BBC Iplayer and BBC News!</p>
        <p>Data is loaded and filtered from 
        <a href="https://confluence.dev.bbc.co.uk/display/~jamie.pitts@bbc.co.uk/Trevor+Example+Endpoints" target="_blank">TREVOR</a> 
        and 
        <a href="https://inspector.ibl.api.bbci.co.uk" target="_blank">IBL</a></p>'

        @fileHtml.puts "<p>Latest scan took place at - #{Time.now.strftime("%d/%m/%Y %H:%M")}</p>"

  end

  #---------------------------------------------------------------------------------

  def addHTMLSideLinks()
    @fileHtml.puts "<div id='side_links'><ul>"
    @side_links.each do |user_heading|
      @fileHtml.puts "<li><a href='##{user_heading}'>#{user_heading}</a></li>"
    end
    @fileHtml.puts "</ul></div>"
  end

  #---------------------------------------------------------------------------------

  def addHTMLFooter()
    @fileHtml.puts '</body></html>'
  end

  #---------------------------------------------------------------------------------

  def printNewsHeader( new_title )
    @fileHtml.puts "<div id='news_div'>"
    @fileHtml.puts "<h2><img id='#{new_title}'src='images/news_icon.jpeg'/> #{new_title}</h2>"
    @side_links.push("#{new_title}")
  end

  #---------------------------------------------------------------------------------

  def printIplayerHeader( new_title )
    @fileHtml.puts "<div id='iplayer_div'>"
    @fileHtml.puts "<h2><img id='#{new_title}'src='images/iplayer_icon.jpeg'/> #{new_title}</h2>"
    @side_links.push("#{new_title}")
  end

  #---------------------------------------------------------------------------------

  def printNewsEntrySummary()
    @fileHtml.puts "<ul class='news_entry_overall_stats'>"
    @entry_summary.each do |item , occurences|
      @fileHtml.puts "<li>#{item} : #{occurences}</li>"
    end
    @fileHtml.puts "</ul>"
  end

  #---------------------------------------------------------------------------------

  def clearNewsEntrySummary()
    @entry_summary = Hash.new(0)
  end

  #---------------------------------------------------------------------------------

  def getIplayerTotal()
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
    @fileHtml.puts "<li><a href='http://www.bbc.co.uk/iplayer/episode/#{new_parent_id}/#{tag}' target='_blank'>iPlayer Link</a></li>"
  end

  #---------------------------------------------------------------------------------

  def createIplayerKindFlag( new_kind )
    if new_kind == "audio-described"
      @fileHtml.puts "<li class='iplayer_kind_flag'>AD</li>"
    elsif new_kind == "signed"
      @fileHtml.puts "<li class='iplayer_kind_flag'>SL</li>"   
    end
  end

  #---------------------------------------------------------------------------------

  def createNewsArticleLink( new_parent_id )
    @fileHtml.puts "<li><a href='#{new_parent_id.sub( "/cps" , "http://www.bbc.co.uk")}' target='_blank'>News Link</a></li>"
  end

  #---------------------------------------------------------------------------------

  def createPipsLink( new_pid )
    return "<a href='https://api.live.bbc.co.uk/pips/inspector/pip/#{new_pid}' target='_blank'>#{new_pid}</a>"
  end

  #---------------------------------------------------------------------------------

  def createAvailabilityLink( new_pid )
     @fileHtml.puts "<li><a href='http://media-availability-tool.tools.bbc.co.uk/#{new_pid}?mediator=http%3A%2F%2Fopen.live.bbc.co.uk' 
     target='_blank'>Availability Link</a></li>"
  end

  #---------------------------------------------------------------------------------

  def createCookBookLink( new_product , new_image , new_title , new_guidance , new_version_id )
    smp_settings = { 'product' => new_product, 'superResponsive' => true }
    smp_playlist = 
    {
      'holdingImageURL' => new_image,
      'title'           => new_title,
      'guidance'        => new_guidance,
      'items' => 
      [ 
        {
          'versionID' => new_version_id
        }
      ]
    }
    encoded_settings = Base64.encode64(smp_settings.to_json).gsub("\n", '')
    encoded_playlist = Base64.encode64(smp_playlist.to_json).gsub("\n", '')
    @fileHtml.puts "<li><a href='http://cookbook.tools.bbc.co.uk/#{new_product}?settings=#{encoded_settings}&playlist=#{encoded_playlist}' 
                    target='_blank'>Cookbook Link</a></li>"
  end

  #---------------------------------------------------------------------------------

  def printNewsEntryInfo( new_index , new_parent , new_version )
    if new_version["content"]["iChefUrl"]
      temp_background_image = "#{new_version["content"]["iChefUrl"].sub("$recipe", "976x549")}"
      @fileHtml.puts "<div class='entry' style='background-image: linear-gradient(rgba(255,255,255,0.8),rgba(255,255,255,1.0)),url(#{temp_background_image})'>"
    else
      @fileHtml.puts "<div class='entry'>"
    end
    @fileHtml.puts "<p>#{new_index}</p>"
    @fileHtml.puts "<ul>"
    @fileHtml.puts "<li class='caption'> #{new_version["content"]["caption"]}                             </li>"
    @fileHtml.puts "<li><hr>                                                                              </li>"
    @fileHtml.puts "<li>Vpid :           #{createPipsLink(new_version["content"]["externalId"])}          </li>"
    @fileHtml.puts "<li><hr>                                                                              </li>"
    @fileHtml.puts "<li>Type :           #{new_version["content"]["type"].sub( "bbc.mobile.news." , "")}  </li>"
    @fileHtml.puts "<li>Embeddable :     #{new_version["content"]["isEmbeddable"]}                        </li>"
    @fileHtml.puts "<li>Available :      #{new_version["content"]["isAvailable"]}                         </li>"
    @fileHtml.puts "<li>Duration :       #{new_version["content"]["duration"]/1000} secs                  </li>"
  
    if new_version["content"]["guidance"]
      @fileHtml.puts "<li>Guidance : #{new_version["content"]["guidance"]}</li>"
    end

    @fileHtml.puts "<li><hr></li>"

    createNewsArticleLink( new_parent )
    createCookBookLink( "news" , temp_background_image, new_version["content"]["caption"] , new_version["content"]["guidance"] , new_version["content"]["externalId"] )
    createAvailabilityLink( new_version["content"]["externalId"] )

    if new_version["content"]["type"] == "bbc.mobile.news.audio"
      @fileHtml.puts "<li class='news_audio_flag'>AUDIO</li>"
    end 
    @fileHtml.puts "</ul></div>"
  end

  #---------------------------------------------------------------------------------

  def printAllNewsVpids( new_title , new_hash )
    index , external_trevor_links, entry_vpids = 0 , [], []
    printNewsHeader( new_title )

    new_hash["relations"].each do |parent|
      parent["content"]["relations"].each do |version|
        
        # Nake a link from parent we may have to use
        parent_link = "http://trevor-producer.api.bbci.co.uk/content#{parent["content"]["id"]}"

        # If current entry has an externalID (vpid) simply print it out and its info to the HTML page
        if version["content"]["externalId"] and not entry_vpids.include? version["content"]["externalId"]
          entry_vpids.push( version["content"]["externalId"] )
          index += 1
          printNewsEntryInfo( index , parent["content"]["id"] , version )

        # Else if there is no externalId and we haven't used the link before then we visit it to check external Trevor link for more vpids!
        elsif not version["content"]["externalId"] and not external_trevor_links.include? parent_link  
          @website_resp = Net::HTTP.get_response(URI.parse(parent_link))
          @website_data = @website_resp.body
          temp_hash = JSON.parse(@website_data)

          # Store current link so we don't revisit the same TREVOR link multiple times
          external_trevor_links.push(parent_link)

          # This loop is for VIDEO in TREVOR
          temp_hash["relations"].each do |video|
            video["content"]["relations"].each do |version|
              if version["content"]["externalId"] and not entry_vpids.include? version["content"]["externalId"]
                entry_vpids.push( version["content"]["externalId"] )
                index += 1
                printNewsEntryInfo( index , video["content"]["id"] , version )
              end
            end
          end
          # This loop is for AUDIO since its stored differently in TREVOR
          temp_hash["relations"].each do |audio|
            if audio["content"]["externalId"] and not entry_vpids.include? audio["content"]["externalId"] and audio["content"]["duration"] > 1
              entry_vpids.push( audio["content"]["externalId"] )
              index += 1
              printNewsEntryInfo( index , parent["content"]["id"] , audio )
            end
          end
        end
      end
    end
  end

  #---------------------------------------------------------------------------------

  def printAllIplayerVpids( new_title , new_hash )
    index = 0
    printIplayerHeader( new_title )
    new_hash["group_episodes"]["elements"].each do |parent|
      parent["versions"].each do |version|
        if parent["images"]["standard"]
          temp_image = "#{parent["images"]["standard"].sub("{recipe}", "976x549")}"
          @fileHtml.puts "<div class='entry' style='background-image: linear-gradient(rgba(255,255,255,0.8),rgba(255,255,255,1.0)),url(#{temp_image})'>"
        else
          @fileHtml.puts "<div class='entry'>"
        end
        @fileHtml.puts "<p>#{index+=1}</p>"
        @fileHtml.puts "<ul>"
        @fileHtml.puts "<li class='title'>    #{parent["title"]}               </li>"
        @fileHtml.puts "<li><hr></li>"
        @fileHtml.puts "<li>Vpid :            #{createPipsLink(version["id"])} </li>"
        @fileHtml.puts "<li>Parent :          #{createPipsLink(parent["id"])}  </li>"
        @fileHtml.puts "<li><hr></li>"
        @fileHtml.puts "<li>Kind :            #{version["kind"]}               </li>"
        @fileHtml.puts "<li>Credits :         #{parent["has_credits"]}         </li>"
        @fileHtml.puts "<li>HD :              #{version["hd"]}                 </li>"
        @fileHtml.puts "<li>Download :        #{version["download"]}           </li>"
        @fileHtml.puts "<li>Duration :        #{version["duration"]["text"]}   </li>"
        @fileHtml.puts "<li>Guidance :        #{parent["guidance"]}            </li>"
        # There's a bug in IBL where a VPID may not display guidance despite its PARENT saying it does!
        temp_guidance = ""
        if parent["guidance"] == true and version["guidance"]
          temp_guidance = version["guidance"]["text"]["medium"]
          @fileHtml.puts "<li>Guidance : #{version["guidance"]["text"]["medium"]} </li>"
        end
        @fileHtml.puts "<li><hr></li>"
        createIplayerLink( parent["id"] , version["kind"] )
        createCookBookLink( "iplayer" , temp_image , parent["title"] , temp_guidance , version["id"] )
        createAvailabilityLink (version["id"] )
        createIplayerKindFlag( version["kind"] )
        @fileHtml.puts "</ul></div>"
      end
    end
  end

  #---------------------------------------------------------------------------------

  def getAndPrint( new_product , new_title , new_link )
    @website_resp = Net::HTTP.get_response(URI.parse(new_link))
    @website_data = @website_resp.body
    @hash = JSON.parse(@website_data)
    if new_product == "NEWS"
      printAllNewsVpids( new_title , @hash )
    elsif new_product == "IPLAYER"
      printAllIplayerVpids( new_title , @hash )
    end
  end
end









