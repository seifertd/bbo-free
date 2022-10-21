class Lin
  attr_accessor :north, :south, :east, :west, :dealer, :hands
  def self.create(lin_data)
    Lin.new(lin_data)
  end

  def initialize(lin_data)
    parse(lin_data)
  end

  private

  def parse(lin_data)
    lin_data.split('|').each_cons(2) do |(command, data)|
      case command
      when 'pn'
       @north, @south, @east, @west = data.split(',')
      when 'md'
        order = [:south, :west, :north, :east]
        cards = %w(2 3 4 5 6 7 8 9 T J Q K A )
        deck = { S: cards.dup, H: cards.dup, D: cards.dup, C: cards.dup }
        @dealer = order[data[0].to_i - 1]
        @hands = Hash[order.zip(data[1..-1].split(','))]
        # determine remaining hand
        @hands.each do |(seat, hand)|
          next if hand.nil?
          suit = nil
          hand.split(//).each do |card|
            case card
            when 'S', 'H', 'D', 'C'
              suit = card.to_sym
            else
              deck[suit].delete card
            end 
          end
        end
        @hands[:east] = "S#{deck[:S].join}H#{deck[:H].join}D#{deck[:D].join}C#{deck[:C].join}"
      end
      self
    end
  end
end
