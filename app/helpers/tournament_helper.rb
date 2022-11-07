module TournamentHelper
  def pretty_hand(hand)
    tag.div do
      safe_join(
        hand.split(//).collect do |char|
          case char
          when 'S'
            tag.span('&spades;'.html_safe, class: 'suit text-black-900')
          when 'C'
            tag.br +
              tag.span('&clubs;'.html_safe, class: 'suit text-black-900')
          when 'H'
            tag.br +
              tag.span('&hearts;'.html_safe, class: 'suit text-xs text-red-900')
          when 'D'
            tag.br + 
              tag.span('&diams;'.html_safe, class: 'suit text-red-900')
          else
            char
          end
        end
      )
    end
  end
end
