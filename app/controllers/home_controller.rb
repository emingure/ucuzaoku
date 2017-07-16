class HomeController < ApplicationController
  def show
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    @content = []
    @q = params[:id]
    Thread.new { find_kitapyurdu a }.join
    Thread.new { find_dr a }.join
    Thread.new { find_idefix a }.join
    Thread.new { find_babil a }.join
    Thread.new { find_pandora a }.join
    Thread.new { find_nadirkitap a }.join

    # ky.join
    # dr.join
    # id.join
    # ba.join
    # pa.join
    # nk.join
  end

  private

  def find_kitapyurdu (a)
    a.get(URI.escape('http://www.kitapyurdu.com/index.php?route=product/search&filter_name='+@q+'&fuzzy=0&filter_product_type=1')) do |search_result|

      search_result.css('div#product-table div').each do |link|
        info = {}

        link.css('div.name a').each do |url|
          info['url'] = url['href']
        end
        link.css('div.image img').each do |img_url|
          info['img_url'] = img_url['src']
        end
        link.css('div.name a span').each do |title|
          info['title'] = title.content
        end

        link.css('div.author span a span').each do |author|
          info['author'] = author.content
        end

        link.css('div.publisher span a span').each do |publisher|
          info['publisher'] = publisher.content
        end

        link.css('div.price div.price-new span.value').each do |price|
          info['price'] = price.content
        end

        unless info['price']
          info['price'] = link.css('div.price span.price-old span.value').first.content
        end

        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end

  def find_dr (a)
    a.get('http://www.dr.com.tr/search?q='+URI.escape(@q)+'&cat=0%2C10001&parentId=10001') do |search_result|

      search_result.xpath('//*[@id="container"]/div').each do |link|
        info = {}

        link.xpath('div[1]/div[1]/a[1]').each do |url|
          info['url'] = 'http://www.dr.com.tr'+url['href']
        end
        link.xpath('figure/a/img').each do |img_url|
          info['img_url'] = img_url['src']
        end
        link.xpath('div[1]/div[1]/a[1]/h3').each do |title|
          info['title'] = title.content
        end
        link.xpath('div[1]/div[1]/a[2]').each do |author|
          info['author'] = author.content
        end
        link.xpath('div[1]/div[1]/a[3]').each do |publisher|
          info['publisher'] = publisher.content
        end

        link.xpath('div[1]/div[2]/span[2]').each do |price|
          info['price'] = price.content
        end

        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end

  def find_idefix (a)
    a.get('http://www.idefix.com/Search?q='+URI.escape(@q)+'&cat=0%2C11693&parentId=11693') do |search_result|

      search_result.xpath('//*[@id="container"]/div').each do |link|
        info = {}

        link.xpath('div[1]/div[1]/a[1]').each do |url|
          info['url'] = 'http://www.idefix.com'+url['href']
        end
        link.xpath('figure/a/img').each do |img_url|
          info['img_url'] = img_url['src']
        end
        link.xpath('div[1]/div[1]/a[1]/h3').each do |title|
          info['title'] = title.content
        end
        link.xpath('div[1]/div[1]/a[2]').each do |author|
          info['author'] = author.content
        end
        link.xpath('div[1]/div[1]/a[3]').each do |publisher|
          info['publisher'] = publisher.content
        end

        link.xpath('div[1]/div[2]/span[2]').each do |price|
          info['price'] = price.content
        end

        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end

  def find_babil (a)
    a.get(URI.escape('http://www.babil.com/arama?q='+@q+'&f_fname=Kitap')) do |search_result|

      search_result.xpath('//*[@id="main"]/div/div/div[1]/div[5]/div').each do |link|
        #if link.text =~ /.*kitapyurdu\.com.*/
        # puts link
        info = {}

        link.xpath('div[2]/div/h2/a').each do |url|
          info['url'] = 'http://www.babil.com'+url['href']
          info['title'] = url.content
        end
        link.xpath('div[1]/div/a/img').each do |img_url|
          info['img_url'] = img_url['src']
        end
        link.xpath('div[2]/div/h3/a').each do |author|
          info['author'] = author.content
        end
        link.xpath('div[2]/div/h4/a').each do |publisher|
          info['publisher'] = publisher.content
        end

        link.xpath('div[2]/div/div[2]/span[2]').each do |price|
          info['price'] = price.content
        end

        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end

  def find_pandora (a)

    a.get(URI.escape('http://www.pandora.com.tr/Arama?text='+@q+'&type=3')) do |search_result|

      search_result.css('li.urunorta').each do |link|
        info = {}
        info['url'] = 'http://pandora.com.tr' + link.css('.imgcont a')[0]['href']
        info['img_url'] = 'http://pandora.com.tr' + link.css('.imgcont a img')[0]['src']
        info['title'] = link.css('.kt').text
        info['author'] = link.css('.yz').text
        info['publisher'] = link.css('.yy').text
        info['price'] = link.css('.se .fyt strong').text

        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end

  def find_nadirkitap (a)
    a.get(URI.escape('http://www.nadirkitap.com/kitapara_sonuc.php?kelime='+@q)) do |search_result|
      search_result.css('ul.product-list li div.product-list-right-top').each do |link|
        info = {}
        info['url'] = link.xpath('div[1]/h4/a')[0]['href']
        info['img_url'] = 'http://www.nadirkitap.com/' + link.parent.parent.xpath('div[1]/a/img')[0]['src']
        info['title'] = link.xpath('div[1]/h4/a/span').text
        info['author'] = link.xpath('div[1]/p').text
        info['publisher'] = link.xpath('div[1]/ul/li[2]/span').text
        info['price'] = link.xpath('div[2]/div[3]').text
        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end
end
