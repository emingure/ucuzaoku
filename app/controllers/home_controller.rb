class HomeController < ApplicationController
  def index
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    @content = []
    Thread.new { find_kitapyurdu a }.join
    Thread.new { find_dr_idefix(a, /.*D&R.*/, 'D&R') }.join
    Thread.new { find_dr_idefix(a, /.*defix.*/, 'idefix') }.join
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
    a.get('http://google.com/') do |page|
      search_result = page.form_with(:id => 'tsf') do |search|
        search.q = 'hayvan cifligi kitapyurdu'
      end.submit

      b = ''
      search_result.links.each do |link|
        if link.text =~ /.*kitapyurdu\.com.*/
          info = {}
          b = a.click(link)
          info['url'] = link.uri
          b.xpath('//div[3]/div/div[1]/div[2]/div/h1').each do |title|
            info['title'] = title.content
          end

          b.xpath('//div[4]/div[2]/div[3]/div/span', '//div[4]/div[2]/div[2]/div/span').each do |price|
            info['price'] = price.content
          end

          if info['price'].present?
            @content << info
            break
          end
        end
      end
    end
  end

  def find_dr_idefix (a,website, website_s)
    a.get('http://google.com/') do |page|
      search_result = page.form_with(:id => 'tsf') do |search|
        search.q = 'elon musk ' + website_s
      end.submit

      b = ''
      search_result.links.each do |link|
        if link.text =~ website
          info = {}
          b = a.click(link)
          info['url'] = link.uri
          b.xpath('//*[@id="catPageContent"]/section[2]/div[2]/div[1]/div[1]/h1', '//*[@id="catPageContent"]/section[2]/div[2]/div[1]/div[1]/h2', '//*[@id="catPageContent"]/section[2]/div[2]/div[1]/div[1]/h3').each do |title|
            info['title'] = title.content
          end

          b.xpath('//*[@id="hdnChar1"]').each do |price|
            info['price'] = price['data-price']
          end

          if info['price'].present?
            @content << info
            break
          end
        end
      end
    end
  end

  def find_babil (a)
    a.get('http://babil.com/') do |page|
      search_result = page.form_with(:id => 'frmSearch') do |search|
        search.q = 'hayvan'
      end.submit

      #puts search_result.content
      search_result.xpath('//*[@id="category_product_display"]/ul/li').each do |link|
        #if link.text =~ /.*kitapyurdu\.com.*/
        info = {}
        info['url'] = 'http://www.babil.com' + link.xpath('div[1]/div[2]/h2/a')[0]['href']
        info['title'] = link.xpath('div[1]/div[2]/h2/a').text
        info['price'] = link.xpath('div[1]/div[2]/div[3]/div[1]/span[1]').text

        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end

  def find_pandora (a)
    a.get('http://pandora.com.tr/') do |page|
      search_result = page.form_with(:action => '/Arama') do |search|
        search['text'] = 'hayvan'
      end.submit

      search_result.css('li.urunorta').each do |link|
        info = {}
        info['url'] = 'http://pandora.com.tr' + link.css('.imgcont a')[0]['href']
        info['title'] = link.css('.kt').text
        info['price'] = link.css('.se .fyt strong').text

        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end

  def find_nadirkitap (a)
    a.get('http://nadirkitap.com/') do |page|
      search_result = page.form_with(:id => 'search-form') do |search|
        search['kelime'] = 'hayvan'
      end.submit

      search_result.css('ul.product-list li div.product-list-right-top').each do |link|
        info = {}
        info['url'] = link.xpath('div[1]/h4/a')[0]['href']
        info['title'] = link.xpath('div[1]/h4/a/span').text
        info['price'] = link.xpath('div[2]/div[3]').text
        if info['price'].present?
          @content << info
          break
        end
      end
    end
  end
end
