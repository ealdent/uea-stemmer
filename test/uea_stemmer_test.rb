# frozen_string_literal: true

require "test_helper"

class UEAStemmerTest < Minitest::Test
  def setup
    @stemmer = UEAStemmer.new
  end

  def test_stems_common_search_and_indexing_tokens
    assert_stems_all(
      "helpers" => "helper",
      "changes" => "change",
      "deaths" => "death",
      "shadows" => "shadow",
      "flies" => "fly",
      "witches" => "witch",
      "makes" => "make",
      "smokes" => "smoke",
      "does" => "do"
    )
  end

  def test_stems_common_past_tense_forms
    assert_stems_all(
      "ordained" => "ordain",
      "killed" => "kill",
      "liked" => "like",
      "helped" => "help",
      "scarred" => "scar",
      "invited" => "invite",
      "exited" => "exit",
      "debited" => "debit",
      "smited" => "smite"
    )
  end

  def test_stems_common_progressive_forms
    assert_stems_all(
      "running" => "run",
      "settings" => "set",
      "timing" => "time",
      "dying" => "die",
      "harping" => "harp",
      "charring" => "char"
    )
  end

  def test_stems_nouns_that_need_a_trailing_e_preserved
    assert_stems_all(
      "abodes" => "abode",
      "escapades" => "escapade",
      "crusades" => "crusade",
      "grades" => "grade",
      "wires" => "wire",
      "acres" => "acre",
      "fires" => "fire",
      "cares" => "care"
    )
  end

  def test_preserves_words_where_aggressive_stemming_would_hurt_search_quality
    assert_stems_all(
      "man" => "man",
      "happiness" => "happiness",
      "basis" => "basis",
      "ring" => "ring",
      "sing" => "sing",
      "bring" => "bring",
      "fling" => "fling",
      "thing" => "thing",
      "nothings" => "nothing",
      "is" => "is",
      "as" => "as",
      "this" => "this",
      "has" => "has",
      "was" => "was",
      "during" => "during",
      "menses" => "menses"
    )
  end

  def test_preserves_numbers_identifiers_and_compound_tokens
    assert_stems_all(
      "12345" => "12345",
      "2026-05-21" => "2026-05-21",
      "field_name" => "field_name",
      "pre-indexed" => "pre-indexed"
    )
  end

  def test_preserves_capitalized_terms_and_singularizes_plural_acronyms
    assert_stems_all(
      "Ruby" => "Ruby",
      "USA" => "USA",
      "FLOSS" => "FLOSS",
      "USAED" => "USAED",
      "MREs" => "MRE",
      "NASAs" => "NASA"
    )
  end

  def test_removes_possessive_apostrophes
    assert_stems_all(
      "dog's" => "dog",
      "dogs'" => "dogs",
      "dog’s" => "dog"
    )
  end

  def test_expands_common_contractions_before_indexing
    assert_stems_all(
      "don't" => "do not",
      "won't" => "will not",
      "can't" => "can not",
      "Can't" => "Can not",
      "I've" => "I have",
      "they're" => "they are",
      "they’re" => "they are",
      "I'm" => "I am",
      "DON'T" => "DO NOT",
      "I'VE" => "I HAVE"
    )
  end

  def test_can_leave_contractions_unexpanded
    stemmer = UEAStemmer.new(nil, nil, skip_contractions: true)

    assert_equal "don't", stemmer.stem("don't")
  end

  def test_configured_length_limits_pass_through_out_of_range_tokens
    stemmer = UEAStemmer.new(5, 3)

    assert_equal "deoxyribonucleicacid", stemmer.stem("deoxyribonucleicacid")
    assert_equal "CAVASSOO", stemmer.stem("CAVASSOO")
  end

  def test_stemming_does_not_mutate_the_input_token
    token = "helpers"

    assert_equal "helper", @stemmer.stem(token)
    assert_equal "helpers", token
  end

  def test_singleton_instance_uses_the_same_stemming_behavior
    assert_equal "run", DefaultUEAStemmer.instance.stem("running")
  end

  def test_stem_with_rule_returns_documented_metadata
    result = @stemmer.stem_with_rule("invited")

    assert_equal "invite", result.word
    assert_equal "22.3", result.rule_num
    assert_match(/rule #22\.3/, result.rule.to_s)
  end

  def test_stem_with_rule_keeps_distinct_decimal_rule_identifiers
    assert_equal "63.10", @stemmer.stem_with_rule("abodes").rule_num
    assert_equal "63.1", @stemmer.stem_with_rule("makes").rule_num
  end

  private

  def assert_stems_all(examples)
    examples.each do |token, expected|
      assert_equal expected, @stemmer.stem(token), "#{token.inspect} should stem to #{expected.inspect}"
    end
  end
end
