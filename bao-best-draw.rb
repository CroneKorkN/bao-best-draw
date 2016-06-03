#!/usr/bin/ruby

class Bao
  def initialize(pitch_width:, stones_per_field:)
    @fields = Array.new(pitch_width*2, stones_per_field)
    @enemy_fields = @fields.dup
  end
  
  def fields
    @fields
  end

  def enemy_fields
    @enemy_fields
  end
  
  def balance
    @fields.inject(0, :+) - @enemy_fields.inject(0, :+)
  end
  
  def draw(field)
    # set position
    @position = field
    
    # take own
    @hand = @fields[@position]
    @fields[@position] = 0
    
    # take from enemy
    if enemy_bordering?
      @hand += @enemy_fields[@position]
      @enemy_fields[@position] = 0
    end
    
    # spread stones
    while @hand > 0
      @position = (@position + 1) % (@fields.count - 1)
      @fields[@position] += 1
      @hand -= 1
    end
    
    # draw again?
    if @fields[@position] >= 2
      draw(@position)
    end
  end
  
  private
  
  def enemy_bordering?
    @position > (@fields.count+1)/2
  end
end


class BaoBestDraw
  def initialize(pitch_width: 8, stones_per_field: 2)
    best = nil
    (pitch_width*2).times do |start_field|
      bao = Bao.new(pitch_width: 8, stones_per_field: 2)
      bao.draw start_field
      if not best or bao.balance > best.balance
        best = bao
      end
    end
    puts best.balance
    puts best.fields.slice(pitch_width, (pitch_width*2)).join(";")
    puts best.fields.slice(0, pitch_width).reverse.join(";")
  end
end

BaoBestDraw.new