#!/usr/bin/ruby

# Model
class Bao
  def initialize fields, enemy_fields
    @fields = fields
    @enemy_fields = enemy_fields
  end
  
  public

  attr_reader :fields, :enemy_fields

  def draw field
    # set position
    @position = field
    
    # take own stones in hand
    @hand = @fields[@position]
    @fields[@position] = 0
    
    p "XXXXXXXXXXXXXXXXXXXXXXXXXX"
    render
    p @hand
      
    # take from enemy
    if enemy_bordering?
      @hand += @enemy_fields[bordering(@position)]
      @enemy_fields[bordering(@position)] = 0
    end
    
    # put stones down
    while @hand > 0
      @position = (@position + 1) % (@fields.length)
      @fields[@position] += 1
      @hand -= 1
      p "XXXXXXXXXXXXXXXXXXXXXXXXXX"
      render
      p @hand
    end
    
    # draw again?
    draw(@position) if @fields[@position] >= 2
  end
    
  def balance
    (@fields.inject(0, :+) - @enemy_fields.inject(0, :+)) / 2
  end
  
  def render
    pitch_width = @fields.length / 2
    p @enemy_fields.slice(0, pitch_width).join(";")
    p @enemy_fields.slice(pitch_width, (pitch_width*2)).reverse.join(";")
    p @fields.slice(pitch_width, (pitch_width*2)).join(";")
    p @fields.slice(0, pitch_width).reverse.join(";")
  end
  
  private
  
  def enemy_bordering?
    # is an enemy field bordering?
    @position > (@fields.count+1)/2
  end
  
  def bordering field
    @fields.length - 1 - (field - @fields.length/2)
  end
end

# Controller
class BaoBestDraw
  def initialize fields, enemy_fields = nil
    # init
    best = nil
    best_draw = nil
    
    # try each field as starting point
    fields.length.times do |start_field|
      start_field = 13
      # start simulation
      bao = Bao.new fields.dup, enemy_fields.dup
      bao.draw start_field
      # have new winner?
      if not best or bao.balance > best.balance
        best = bao
        best_draw = start_field
      end
      break
    end
    

    # render
    p "best draw: #{best_draw}; #{best.balance} stones stolen"
    best.render
  end
  
  private
  
  def ___render bao
    pitch_width = bao.fields.length / 2
    buffer = bao.enemy_fields.slice(0, pitch_width).join(";")
    buffer += "\n" + bao.enemy_fields.slice(pitch_width, (pitch_width*2)).reverse.join(";")
    buffer += "\n" + bao.fields.slice(pitch_width, (pitch_width*2)).join(";")
    buffer += "\n" + bao.fields.slice(0, pitch_width).reverse.join(";")
  end
end

# parse params
default = "2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2"
fields = (
  Hash[ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/)]["fields"] || default
).split(";").map(&:to_i)
enemy_fields = (
  Hash[ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/)]["enemy_fields"] || default
).split(";").map(&:to_i)

# go!
BaoBestDraw.new fields, enemy_fields