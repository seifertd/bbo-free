class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all.order(tourney_date: :desc)
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def create
    parser = BboParser.new(params[:tournament_results_html])
    @tournament, entry, new_tourney = parser.parse
    respond_to do |format|
      puts "FORMAT: #{format.inspect}"
      format.turbo_stream
      format.html do
        if new_tourney
          redirect_to action: 'index', success: "Entry #{entry.player} was recorded!"
        else
          redirect_to action: 'index', info: "Entry #{entry.player} was updated!"
        end
      end
    end
  rescue Exception => e
    Rails.logger.error e
    flash.alert = e.message
    #redirect_to action: 'index'
    raise e
  end

end
