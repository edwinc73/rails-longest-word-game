require 'open-uri'

class GamesController < ApplicationController
  def new
    @startTime = DateTime.now
    @letters = ("a".."z").to_a.sample(10)
  end

  def score
    startTime = DateTime.parse(params[:start_time]).to_i
    @score = 0
    @game = params[:game]
    @tips = "get good kid"
    input = params[:input]
    response = checkDictionary(input)
    if response["found"]
      if onTheBoard?(input)
        @score = setScore(startTime, input)
        @tips = "Well done!"
      else
        @tips = "Try using the words available"
      end
    else
      @tips = response["error"]
    end
  end

  private
  def setScore(startTime, input)
    (input.length * 10) - ((DateTime.now.to_i - startTime) / 5)
  end

  def onTheBoard?(input)
    gameboard = @game.split(" ")
    split = input.split("")
    return false if split.length > gameboard.length

    split.each do |letter|
      if gameboard.include?(letter)
        gameboard.delete_at(gameboard.index(letter))
      else
        return false
      end
    end
    return true
  end

  def checkDictionary(input)
    url = "https://wagon-dictionary.herokuapp.com/#{input.to_s}"
    response = JSON.parse(URI.open(url).read)
  end

end
