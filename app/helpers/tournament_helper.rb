module TournamentHelper
  def pretty_hand(hand)
    tag.table do
      rows = []
      hand.scan /([SHDC]{1})([^SHDC]*)/ do |suit, cards|
        rows << tag.tr do
          cols = []
          case suit
          when 'S'
            cols << tag.td('&spades;'.html_safe, class: 'suit text-black-900')
          when 'C'
            cols << tag.td('&clubs;'.html_safe, class: 'suit text-black-900')
          when 'H'
            cols << tag.td('&hearts;'.html_safe, class: 'suit text-xs text-red-900')
          when 'D'
            cols << tag.td('&diams;'.html_safe, class: 'suit text-red-900')
          end
          cols << tag.td(cards.reverse)
          safe_join cols
        end
      end
      safe_join rows
    end
  end
end
