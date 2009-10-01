require 'test_helper'

class UeaStemmerTest < Test::Unit::TestCase
  context "A default UEAStemmer instance" do
    setup do
      @stemmer = UEAStemmer.new
    end

    should "have max word and max acronym sizes equivalent to deoxyribonucleicacid and CAVASSOO respectively" do
      assert @stemmer.max_word_length == 'deoxyribonucleicacid'.size
      assert @stemmer.max_acronym_length == 'CAVASSOO'.size
    end

    context "stem method" do
      should "stem words as Strings" do
        assert @stemmer.stem('word').is_a?(String)
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
        assert_equal @stemmer.stem('invited'), 'invite'
        assert_equal @stemmer.stem('exited'), 'exit'
        assert_equal @stemmer.stem('exited'), 'exit'
        assert_equal @stemmer.stem('debited'), 'debit'
        assert_equal @stemmer.stem('smited'), 'smite'
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
        assert_equal @stemmer.stem('makes'), 'make'
        assert_equal @stemmer.stem('smokes'), 'smoke'
        assert_equal @stemmer.stem('does'), 'do'
      end

      should "stem acronyms when pluralized otherwise they should be left alone" do
        assert_equal @stemmer.stem('USA'), 'USA'
        assert_equal @stemmer.stem('FLOSS'), 'FLOSS'
        assert_equal @stemmer.stem('MREs'), 'MRE'
        assert_equal @stemmer.stem('USAED'), 'USAED'
      end
    end

    context "stem_with_rule method" do
      should "return a Word instance" do
        assert @stemmer.stem_with_rule('witches').is_a?(UEAStemmer::Word)
      end

      should "return a rule and the stemmed form" do
        word = @stemmer.stem_with_rule('witches')
        assert !word.rule.nil?
        assert !word.word.nil?
      end
    end

    context "other functionality" do
      should "return the number of rules the stemmer is currently using" do
        assert @stemmer.num_rules.is_a?(Numeric)
      end
    end
  end

  context "A modified UEAStemmer instance" do
    setup do
      @stemmer = UEAStemmer.new(5, 3)     # max word length = 5, max acronym length = 3
    end

    should "have modified max word and max acronym sizes" do
      assert @stemmer.max_word_length == 5
      assert @stemmer.max_acronym_length == 3
    end

    should "reject a longer word with rule 95" do
      word = @stemmer.stem_with_rule('deoxyribonucleicacid')
      assert_equal word.rule_num, 95
    end

    should "reject a longer acronym with rule 96" do
      word = @stemmer.stem_with_rule('CAVASSOO')
      assert_equal word.rule_num, 96
    end
  end

  context "A Word instance" do
    setup do
      @word = UEAStemmer::Word.new('helpers', 68, UEAStemmer::EndingRule.new('s', 1, 68)) # sample word
      @stemmer = UEAStemmer.new
    end

    should "return the rule used to derive the stem" do
      assert @word.rule.kind_of?(UEAStemmer::Rule)
    end

    should "return the number of the rule used to derive the stem" do
      assert @word.rule_num.kind_of?(Numeric)
    end

    should "return the stemmed word as a String" do
      assert @word.word.kind_of?(String)
    end
  end

  context "A Rule instance" do
    setup do
      @rule = UEAStemmer::Rule.new(/.*s$/i, 1, 555)
    end

    should "return the rule number" do
      assert @rule.rule_num.kind_of?(Numeric)
    end

    should "return the pattern being matched" do
      assert @rule.pattern.kind_of?(String) || @rule.pattern.kind_of?(Regexp)
    end

    should "return the size of the suffix that is being removed" do
      assert @rule.suffix_size.kind_of?(Numeric)
    end

    should "return a stemmed word, a rule number, and a rule on a successful match" do
      word, rule_num, tmp_rule = @rule.handle('helps')
      assert word.is_a?(String) && rule_num.is_a?(Numeric) && tmp_rule.is_a?(UEAStemmer::Rule)
    end

    should "return nil when match is unsuccessful" do
      assert @rule.handle('help').nil?
    end
  end
end
