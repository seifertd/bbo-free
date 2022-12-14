class TournamentsController < ApplicationController
  before_action :clear_flash
  def index
    @tournaments = Tournament.all.order(tourney_date: :desc).limit(10)
  end

  def show
    @tournament = Tournament.find(params[:id])
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
    parser = BboParser.new(params[:tournament_results_html])
    @tournament, entry, @new_tourney = parser.parse
    if @new_tourney
      flash.now[:success] = "Entry #{entry.player} was recorded!"
    else
      flash.now[:info] = "Entry #{entry.player} was updated!"
    end
    respond_to do |format|
      format.turbo_stream
      format.html do
        if new_tourney
          redirect_to action: 'index'
        else
          redirect_to action: 'index'
        end
      end
    end
  rescue Exception => e
    Rails.logger.error e
    flash.alert = e.message
    #redirect_to action: 'index'
    raise e
  end

private
  def clear_flash
    flash.discard
  end

end
