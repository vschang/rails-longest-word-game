require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def valid?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    serialized_words = URI.open(url).read
    words = JSON.parse(serialized_words)
    # the word is made from the 10 letters
    user_word_array = params[:word].split('')
    if user_word_array.difference(@letters).any? == false
      ## english word AND made from the 10 letters
      if words['found'] && params[:word] == words['word']
        @score = "Congratulations! #{params[:word]} is a valid English word"
      ## word is not english
      elsif !words['found']
        @score = "Sorry, but #{params[:word]} is not a valid English word"
      end
      ## word is not made from the 10 letters
    else
      @score = "Sorry, but #{params[:word]} cannot be made from #{@letters}"
    end
  end

  def score
    @letters = params[:letters].split
    valid?(params[:word])
  end
end
