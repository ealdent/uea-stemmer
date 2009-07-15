require 'test_helper'

class UeaStemmerTest < Test::Unit::TestCase
  context "A Stemmer instance" do
    setup do
      @stemmer = UEAStemmer.new
    end

    should "have max word and max acronym sizes equivalent to deoxyribonucleicacid and CAVASSOO respectively" do
      assert @stemmer.max_word_length == 'deoxyribonucleicacid'.size
      assert @stemmer.max_acronym_length == 'CAVASSOO'.size
    end

    should "stem words as Strings" do
      assert @stemmer.stem('word').is_a?(String)
    end

    should "stem words as Words in decorated mode" do
      assert @stemmer.decorated_stem('word').is_a?(UEAStemmer::Word)
    end

    should "stem base words to just the base word" do
      assert_equal @stemmer.stem('man'), 'man'
      assert_equal @stemmer.stem('happiness'), 'happiness'
    end

    should "stem theses as thesis but not bases as basis" do
      assert_equal @stemmer.stem('theses'), 'thesis'
      assert_not_equal @stemmer.stem('bases'), 'basis'
    end

    should "stem preterite words ending in -ed without the -ed" do
      assert_equal @stemmer.stem('ordained'), 'ordain'
      assert_equal @stemmer.stem('killed'), 'kill'
      assert_equal @stemmer.stem('liked'), 'like'
      assert_equal @stemmer.stem('helped'), 'help'
      assert_equal @stemmer.stem('scarred'), 'scar'
    end

    should "stem progressive verbs and gerunds without the -ing" do
      assert_equal @stemmer.stem('running'), 'run'
      assert_equal @stemmer.stem('settings'), 'set'
      assert_equal @stemmer.stem('timing'), 'time'
      assert_equal @stemmer.stem('dying'), 'die'
      assert_equal @stemmer.stem('harping'), 'harp'
      assert_equal @stemmer.stem('charring'), 'char'
    end

    should "stem various plural nouns and 3rd-pres verbs without the -s/-es" do
      assert_equal @stemmer.stem('changes'), 'change'
      assert_equal @stemmer.stem('deaths'), 'death'
      assert_equal @stemmer.stem('shadows'), 'shadow'
      assert_equal @stemmer.stem('flies'), 'fly'
      assert_equal @stemmer.stem('things'), 'thing'
      assert_equal @stemmer.stem('nothings'), 'nothing'   # as in 'sweet nothings'
      assert_equal @stemmer.stem('witches'), 'witch'
    end

    # assert @stemmer.stem('') == ''
  end
end
