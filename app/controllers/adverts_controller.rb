class AdvertsController < LeafablesController
  private
    def new_leafable
      Advert.new leafable_params
    end

    def leafable_params
      params.fetch(:advert, {}).permit(:headline, :body_text, :destination_url, :cta_text, :advertiser_name, :image)
    end

    def default_leaf_params
      { title: "Advertisement" }
    end
end
