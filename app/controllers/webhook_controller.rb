class WebhookController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:product_updated]

  def product_updated
    puts params

    p = ShopifyAPI::Product.find params["id"]

    Metafields.product p

    head :ok
  end

end