class GoodreadsController < ApplicationController

  def show
    response = HTTParty.get(URI.escape('https://www.goodreads.com/search/index.xml?q='+params[:id]+'&key=6frrJyr2SZfCMscFNDjDvA'))
    if response.success?
      doc = Nokogiri::XML.parse(response.to_s)
      @books = doc.xpath('//best_book')

      # title = @books.first.xpath('title').text
      # isbn = response['items'][0]['volumeInfo']['industryIdentifiers'][0]['identifier'] if response['items'][0]['volumeInfo']['industryIdentifiers'].present?
      # redirect_to :controller => 'home', :action => 'show', :id => title and return

    end
  end

end
