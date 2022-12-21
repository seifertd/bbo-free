class EntriesController < ApplicationController
  def show
    @entry = Entry.find(params[:id])
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
end
