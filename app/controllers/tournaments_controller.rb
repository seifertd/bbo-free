class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all.order(id: :desc)
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def create
    html = Nokogiri::HTML(params["tournament_results_html"]);
    #Rails.logger.debug("HTML:\n#{html.to_xhtml(indent: 2)}")

    row_count = 1
    @tournment = nil
    entry = nil
    date_info = nil
    html.xpath("/html/body//tr").each do |row|
      if row_count == 1
        tourny_info = row.xpath("th").first
        player, guid = tourny_info.text.split(":").last.split("-")[0,2]
        @tournament = Tournament.where(guid: guid).first_or_initialize
        entry = @tournament.entries.where(player: player).first_or_initialize
      elsif row_count == 2
        date_info = row.xpath("th").first.text
        entry.played_at = date_info
      elsif row.attr("class") == "tourneySummary"
        entry.rank = row.css("td.tourneyPlace").first.text.to_i
        entry.score = row.css("td.tourneyScore").first.text.to_f
      elsif row.attr("class") == "tourney"
        board_num = row.css("td.handnum").first.text.to_i
        board = entry.boards.where(number: board_num).first_or_initialize
        board.played_at = Time.parse(row.css("td:nth-child(2)").first.text).change(date: entry.played_at)
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
        board.lin_data = CGI.unescape(movie_anchors[0]['onclick'].split(';').first.
          gsub("hv_popuplin('","").gsub("')", ""))
        board.lin_url = movie_anchors[1]['href']
        board.traveller_url = row.css("td.traveller a").first['href'];
        board.save!
      end
      row_count += 1
    end
    if @tournament.nil?
      raise "Could not create entry into tournment"
    end
    new_record = @tournament.new_record?
    entry.save!
    @tournament.save!
    if new_record
      flash[:success] = "Entry was recorded!"
    else
      flash[:info] = "Entry #{entry.player} of tournament #{@tournament.guid} was updated!"
    end
    redirect_to action: 'index'
  rescue Exception => e
    flash.alert = e.message
    redirect_to action: 'index'
  end
end
