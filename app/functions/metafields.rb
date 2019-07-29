class Metafields

  def self.product(p)
    
    if ShopifyAPI.credit_left < 20
      puts Colorize.orange('sleeping...')
      sleep 3
    end

    print Colorize.green(p.title)
    puts Colorize.bright(' ' + ShopifyAPI.credit_left.to_s)

    lowest_price = 1000000000
    for v in p.variants
      v.add_metafield(ShopifyAPI::Metafield.new({
        namespace: 'global',
        key: 'usd_price',
        value: v.price,
        value_type: 'string'
      }))

      if v.price.to_f < lowest_price
        lowest_price = v.price
      end
      puts Colorize.cyan(v.price)
    end

    puts Colorize.magenta(lowest_price)

    unless lowest_price == 1000000000
      p.add_metafield(ShopifyAPI::Metafield.new({
        namespace: 'global',
        key: 'usd_price',
        value: lowest_price,
        value_type: 'string'
      }))
    end

  end

  def self.all_products

    pages = (ShopifyAPI::Product.count / 250).ceil

    for page in (1..pages)
      for p in ShopifyAPI::Product.find(:all, params: {limit: 250, page: page})
        product(p)
      end
    end

  end
end