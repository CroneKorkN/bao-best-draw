#!/usr/bin/ruby

class Bao
  def initialize(pitch_width: 8)
    @fields = Array.new(pitch_width*2, 2)
    @enemy_fields = Array.new(pitch_width*2, 2)
  end
  
  def draw(field)
    @position = field
    @hand = @fields[@position]
    @fields[@position] = 0
    while @hand > 0
      @position = (@position + 1) % (@fields.count - 1)
      @fields[@position] += 1
      @hand -= 1
    end
    if @fields[@position] >= 2
      draw(@position)
    end
    puts @fields
  end
  
  private
  
  attr_accessor @hand = 0
  attr_accessor @position = 0
end


class BaoBestDraw
  def initialize(pitch_width: 8)
    best_draw, best_balance = 0, 0
    
    (pitch_width*2-1).times do |start_field|
      bao = Bao.new
      bao.draw start_field
      if bao.balance 
    end
  end
end