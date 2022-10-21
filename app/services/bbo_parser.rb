class BboParser
  def initialize(html)
    @html = Nokogiri::HTML(html)
  end

  def parse
    # Parse everything
    tourney_guid = parse_tourney_guid
    row_count = 1
    new_tourney = tournament = entry = player = player_guid = nil
    Tournament.transaction do
      @html.xpath("/html/body//tr").each do |row|
        if row_count == 1
          tourny_info = row.xpath("th").first
          player, player_guid = tourny_info.text.split(":").last.split("-")[0,2]
        elsif row_count == 2
          played_date = Date.parse(row.xpath("th").first.text)
          tournament = Tournament.where(guid: tourney_guid).first_or_initialize do |tourney|
            tourney.tourney_date = played_date.prev_occurring(:friday)
          end
          entry = tournament.entries.where(player: player).first_or_initialize
          entry.played_at = played_date
        elsif row.attr("class") == "tourneySummary"
          entry.rank = row.css("td.tourneyPlace").first.text.to_i
          entry.score = row.css("td.tourneyScore").first.text.to_f
          tournament.name = row.css("td.tourneyName a").first.text
        elsif row.attr("class") == "tourney"
          board_num = row.css("td.handnum").first.text.to_i
          board = entry.boards.where(number: board_num).first_or_initialize
          board.played_at = Time.parse(row.css("td:nth-child(2)").first.text).
            change(year: entry.played_at.year, month: entry.played_at.month,
                   day: entry.played_at.day)
          board.north = row.css("td.north").first.text
          board.south = row.css("td.south").first.text
          board.east = row.css("td.east").first.text
          board.west = row.css("td.west").first.text
          board.result = row.css("td.result").first.text
          score_cells = row.css("td.score, td.negscore")
          if score_cells.size == 2
            board.points = score_cells.first.text.to_i
            board.score = score_cells.last.text.to_f
          end
          movie_anchors = row.css("td.movie a");
          board.movie_url = movie_anchors[0]['href']
          board.lin_data = lin_from_anchor(movie_anchors[0])
          #board.lin_data = CGI.unescape(movie_anchors[0]['onclick'].split(';').first.
          #  gsub("hv_popuplin('","").gsub("')", ""))
          board.lin_url = movie_anchors[1]['href']
          board.traveller_url = row.css("td.traveller a").first['href'];
          board.save!
        end
        row_count += 1
      end
      if tournament.nil?
        raise "Could not create entry into tournament"
      end
      new_tourney = tournament.new_record?
      new_entry = entry.new_record?
      entry.save!
      tournament.save!
      if tournament.entries.size > 1
        tournament.recalculate!
      end
    end
    [tournament, entry, new_tourney]
  end

  def parse_tourney_guid
    # Get the hands to create a tournament unique identifier
    board = 1
    board_str = ""
    @html.css("html body td.movie a[onclick]").each do |elem|
      lin = Lin.create(lin_from_anchor(elem))
      board_str << "#{board}:#{lin.hands.to_s}|"
      board += 1
    end
    Digest::SHA2.hexdigest board_str
  end

  private 

  def lin_from_anchor(a)
    CGI.unescape(a['onclick'].split(';').first.gsub("hv_popuplin('","").gsub("')", ""))
  end

end
