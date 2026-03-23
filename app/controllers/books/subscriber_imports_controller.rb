class Books::SubscriberImportsController < ApplicationController
  include BookScoped

  before_action :ensure_editable

  def new
  end

  def create
    csv_data = params[:csv_file].read
    SubscriberImportJob.perform_later(@book.id, csv_data)

    redirect_to book_slug_path(@book), notice: "Import started. Subscribers will appear shortly."
  end
end
