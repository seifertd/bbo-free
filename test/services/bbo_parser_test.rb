require "test_helper"

class BboParserTest < ActiveSupport::TestCase
  def setup
    @tourney_html = File.read(File.join(Rails.root, 'test', 'data', 'new_tourney.html'))
  end
  def test_can_parse_new_tournament
    parser = BboParser.new(@tourney_html)
    tournament, entry, new_tourney = parser.parse
    assert tournament.id.present?
    assert entry.id.present?
    assert new_tourney, "tournament is not a new record"
  end
  def test_can_update_existing_entry
    parser = BboParser.new(@tourney_html)
    tournament, entry, new_tourney = parser.parse
    tournament, entry, new_tourney = parser.parse
    assert tournament.id.present?
    assert entry.id.present?
    assert !new_tourney, "tournament is a new record"
  end
end
