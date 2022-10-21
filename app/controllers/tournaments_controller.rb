class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all.order(id: :desc)
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def create
    parser = BboParser.new(params[:tournament_results_html])
    @tournament, entry, new_tourney = parser.parse
    if new_tourney
      flash[:success] = "Entry #{entry.player} was recorded!"
    else
      flash[:info] = "Entry #{entry.player} was updated!"
    end
    redirect_to action: 'index'
  rescue Exception => e
    Rails.logger.error e
    flash.alert = e.message
    #redirect_to action: 'index'
    raise e
  end

  private

end
