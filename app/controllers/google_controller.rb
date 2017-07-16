class GoogleController < ApplicationController

  def index
    books = GoogleBooks.search('hayvan')
    @books = books.first(5)
  end

  def show
    response = HTTParty.get(URI.escape('https://www.googleapis.com/books/v1/volumes?q='+params[:id]+'&langRestrict=tr&maxResults=5&printType=books&projection=full&orderBy=relevance'))
    if response.success?
      # title = response['items'][0]['volumeInfo']['title']
      # isbn = response['items'][0]['volumeInfo']['industryIdentifiers'][0]['identifier'] if response['items'][0]['volumeInfo']['industryIdentifiers'].present?
      # redirect_to :controller => 'home', :action => 'show', :id => title and return
      @books = response
    end
    # books = GoogleBooks.search(params[:id], {:langRestrict => "tr"})
    # @books = books.first(5)
  end
end
