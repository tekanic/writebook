class AdvertsController < LeafablesController
  private
    def new_leafable
      Advert.new leafable_params
    end

    def leafable_params
      params.fetch(:advert, {}).permit(:headline, :body_text, :destination_url, :cta_text, :advertiser_name, :image)
        .with_defaults(headline: default_headline)
    end

    def default_headline
      params.dig(:leaf, :title) || "Advertisement"
    end

    def default_leaf_params
      { title: "Advertisement" }
    end
end
