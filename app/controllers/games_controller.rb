class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split()

    if word_exists?(@word) == false
      @message = "sorry but #{@word.upcase} does not seem to be a valid English word ..."
    elsif in_the_grid?(@word, @letters) == false
      @message = "sorry but #{@word.upcase} cant be built out of #{@letters}"
    elsif word_exists?(@word) && in_the_grid?(@word, @letters)
      @message = "Congratulation! #{@word.upcase} is a valid english word."
    end
  end

  private

  def word_exists?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    attempt_validation = open(url).read
    api_hash = JSON.parse(attempt_validation)
    # {"found" : true ou false,"word" : le mot attempt,"length" : nb de lettres)
    api_hash['found']
  end

  def in_the_grid?(word, letters)
    word.each_char do |letter|
      if letters.include?(letter.upcase)
        letters.delete_at(letters.index(letter))
      else
        return false
      end
    end
    return true
  end
end
