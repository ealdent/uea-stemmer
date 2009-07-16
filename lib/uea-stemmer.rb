#
# Copyright 2005 University of East Anglia
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#
# Authored by Marie-Claire Jenkins and Dr. Dan J. Smith.  Ported to Java
# from Perl by Richard Churchill.  Ported from Java to Ruby by Jason M. Adams.
#

require 'uea-stemmer/rule'
require 'uea-stemmer/word'
require 'uea-stemmer/string_helpers'
require 'singleton'

class UEAStemmer
  include StringHelpers

  attr_accessor :max_acronym_length, :max_word_length
  attr_reader :rules

  def initialize(max_word_length = nil, max_acronym_length = nil)
    @max_word_length = max_word_length || 'deoxyribonucleicacid'.size
    @max_acronym_length = max_acronym_length || 'CAVASSOO'.size

    @rules = Array.new
    create_rules
  end

  def stem_with_rule(word)
    stemmed_word = word.dup;
    ruleno = 0;

    if problem_word?(word)
      Word.new(word, 94)
    elsif (word.size > @max_acronym_length && word =~ /^[A-Z]+$/) || (word.size > (@max_acronym_length + 1) && word =~ /^[A-Z]+s$/)
      Word.new(word, 96)      # added by JMA to catch long acronyms
    elsif word.size > @max_word_length
      Word.new(word, 95)
    elsif word.index("'")
      if word =~ /^.*'[s]$/i
        stemmed_word = remove_suffix(stemmed_word, 2)
      elsif word =~ /^.*'$/
        stemmed_word = remove_suffix(stemmed_word, 1)
      end

      stemmed_word.gsub!(/n't/, ' not')
      stemmed_word.gsub!(/'ve/, ' have')
      stemmed_word.gsub!(/'re/, ' are')
      stemmed_word.gsub!(/'m/, ' am')

      Word.new(stemmed_word, 93)
    else
      stemmed_word, rule_num, rule = apply_rules(stemmed_word)
      Word.new(stemmed_word, rule_num, rule)
    end
  end

  def stem(word)
    stem_with_rule(word).word
  end

  def num_rules
    @rules.map { |r| r.rule_num }.uniq.size + 4    # four rules not covered by the rules array
  end

  def add_rule(rule)
    if rule.kind_of?(Rule)
      @rules << rule.dup.freeze
      true
    else
      false
    end
  end

  private

  def apply_rules(word)
    @rules.each do |rule|
      stemmed_word, rule_num, tmp_rule = rule.handle(word)
      return [stemmed_word, rule_num, rule] if stemmed_word && rule_num
    end

    [word, 0, nil]
  end

  def create_rules
    @rules << Rule.new(/^\d+$/, 0, 90.3)
    @rules << Rule.new(/^\w+-\w+$/, 0, 90.2)
    @rules << Rule.new(/^.*-.*$/, 0, 90.1)
    @rules << Rule.new(/^.*_.*$/, 0, 90)
    @rules << Rule.new(/^[A-Z]+s$/, 1, 91.1)
    @rules << Rule.new(/^[A-Z]+$/, 0, 91)
    @rules << Rule.new(/^((.*[A-Z].*[A-Z])|([A-Z]{1})).*$/, 0, 92)

    @rules << EndingRule.new('aceous', 6, 1)
    @rules << EndingRule.new('ces', 1, 2)
    @rules << EndingRule.new('cs', 0, 3)
    @rules << EndingRule.new('sis', 0, 4)
    @rules << EndingRule.new('tis', 0, 5)
    @rules << EndingRule.new('ss', 0, 6)

    # plural change - this differs from Perl v1.03
    @rules << EndingRule.new('eed', 0, 7)
    @rules << EndingRule.new('eeds', 1, 7)

    @rules << EndingRule.new('ued', 1, 8)
    @rules << EndingRule.new('ues', 1, 9)
    @rules << EndingRule.new('ees', 1, 10)
    @rules << EndingRule.new('iases', 2, 11.4)
    @rules << EndingRule.new('uses', 1, 11.3)
    @rules << EndingRule.new('sses', 2, 11.2)
    @rules << ConcatenatingEndingRule.new('eses', 2, 11.1, 'is')
    @rules << EndingRule.new('ses', 1, 11)
    @rules << EndingRule.new('tled', 1, 12.5)
    @rules << EndingRule.new('pled', 1, 12.4)
    @rules << EndingRule.new('bled', 1, 12.3)

    @rules << EndingRule.new('eled', 2, 12.2)
    @rules << EndingRule.new('lled', 2, 12.1)
    @rules << EndingRule.new('led', 2, 12)
    @rules << EndingRule.new('ened', 2, 13.7)
    @rules << EndingRule.new('ained', 2, 13.6)
    @rules << EndingRule.new('erned', 2, 13.5)
    @rules << EndingRule.new('rned', 2, 13.4)
    @rules << EndingRule.new('nned', 2, 13.3)
    @rules << EndingRule.new('oned', 2, 13.2)
    @rules << EndingRule.new('gned', 2, 13.1)
    @rules << EndingRule.new('ned', 1, 13)
    @rules << EndingRule.new('ifted', 2, 14)
    @rules << EndingRule.new('ected', 2, 15)
    @rules << EndingRule.new('vided', 1, 16)
    @rules << EndingRule.new('ved', 1, 17)
    @rules << EndingRule.new('ced', 1, 18)
    @rules << EndingRule.new('arred', 3, 19.1)
    @rules << NonExhaustiveEndingRule.new('erred', 3, 19)
    @rules << EndingRule.new('urred', 3, 20.5)
    @rules << EndingRule.new('lored', 2, 20.4)
    @rules << EndingRule.new('eared', 2, 20.3)
    @rules << EndingRule.new('tored', 2, 20.2)
    @rules << EndingRule.new('ered', 2, 20.1)

    # plural change - this differs from Perl v1.03
    @rules << EndingRule.new('red', 1, 20)
    @rules << EndingRule.new('reds', 2, 20)
    @rules << EndingRule.new('tted', 3, 21)

    # added some rules to handle invited vs. exited
    @rules << EndingRule.new('noted', 1, 22.6)
    @rules << EndingRule.new('leted', 1, 22.5)
    @rules << Rule.new(/^.*[^vm]ited$/, 2, 22.4)
    @rules << Rule.new(/^.*[vm]ited$/, 1, 22.3)
    @rules << EndingRule.new('uted', 1, 22.2)
    @rules << EndingRule.new('ated', 1, 22.1)
    @rules << EndingRule.new('ted', 2, 22)

    @rules << EndingRule.new('anges', 1, 23)
    @rules << EndingRule.new('aining', 3, 24)
    @rules << EndingRule.new('acting', 3, 25)

    # plural change - this differs from Perl v1.03
    @rules << EndingRule.new('tting', 4, 26)
    @rules << EndingRule.new('ttings', 5, 26)

    @rules << EndingRule.new('viding', 3, 27)
    @rules << EndingRule.new('ssed', 2, 28)
    @rules << EndingRule.new('sed', 1, 29)
    @rules << EndingRule.new('titudes', 1, 30)

    # added some additional rules to handle other vowels and consonants
    # (added by Jason M. Adams)
    @rules << EndingRule.new('oked', 1, 31.1)
    @rules << EndingRule.new('aked', 1, 31.1)
    @rules << EndingRule.new('iked', 1, 31.1)
    @rules << EndingRule.new('uked', 1, 31.1)
    @rules << EndingRule.new('amed', 1, 31)
    @rules << EndingRule.new('imed', 1, 31)
    @rules << EndingRule.new('umed', 1, 31)

    @rules << EndingRule.new('ulted', 2, 32)
    @rules << ConcatenatingEndingRule.new('uming', 3, 33, 'e')
    @rules << EndingRule.new('fulness', 4, 34)
    @rules << EndingRule.new('ousness', 4, 35)
    @rules << EndingRule.new('rabed', 1, 36.1)
    @rules << EndingRule.new('rebed', 1, 36.1)
    @rules << EndingRule.new('ribed', 1, 36.1)
    @rules << EndingRule.new('robed', 1, 36.1)
    @rules << EndingRule.new('rubed', 1, 36.1)
    @rules << EndingRule.new('bed', 2, 36)
    @rules << EndingRule.new('beds', 3, 36)
    @rules << EndingRule.new('ssing', 3, 37)
    @rules << EndingRule.new('ssings', 4, 37)
    @rules << EndingRule.new('ulting', 3, 38)

    # plural change - this differs from Perl v1.03
    @rules << ConcatenatingEndingRule.new('ving', 3, 39, 'e')
    @rules << ConcatenatingEndingRule.new('vings', 4, 39, 'e')

    @rules << EndingRule.new('eading', 3, 40.7)
    @rules << EndingRule.new('eadings', 4, 40.7)
    @rules << EndingRule.new('oading', 3, 40.6)
    @rules << EndingRule.new('oadings', 4, 40.6)
    @rules << EndingRule.new('eding', 3, 40.5)
    @rules << EndingRule.new('edings', 4, 40.5)
    @rules << EndingRule.new('dding', 4, 40.4)
    @rules << EndingRule.new('ddings', 5, 40.4)
    @rules << EndingRule.new('lding', 3, 40.3)
    @rules << EndingRule.new('ldings', 4, 40.3)
    @rules << EndingRule.new('rding', 3, 40.2)
    @rules << EndingRule.new('rdings', 4, 40.2)
    @rules << EndingRule.new('nding', 3, 40.1)
    @rules << EndingRule.new('ndings', 4, 40.1)

    # plural change - this differs from Perl v1.03
    @rules << ConcatenatingEndingRule.new('ding', 3, 40, 'e')
    @rules << ConcatenatingEndingRule.new('dings', 4, 40, 'e')

    @rules << EndingRule.new('lling', 4, 41)
    @rules << EndingRule.new('llings', 5, 41)
    @rules << EndingRule.new('ealing', 3, 42.4)
    @rules << EndingRule.new('ealings', 4, 42.4)
    @rules << EndingRule.new('oling', 3, 42.3)
    @rules << EndingRule.new('olings', 4, 42.3)
    @rules << EndingRule.new('ailing', 3, 42.2)
    @rules << EndingRule.new('ailings', 4, 42.2)
    @rules << EndingRule.new('eling', 3, 42.1)
    @rules << EndingRule.new('elings', 4, 42.1)
    @rules << ConcatenatingEndingRule.new('ling', 3, 42, 'e')
    @rules << ConcatenatingEndingRule.new('lings', 4, 42, 'e')
    @rules << EndingRule.new('nged', 1, 43.2)
    @rules << EndingRule.new('gged', 3, 43.1)
    @rules << EndingRule.new('ged', 1, 43)
    @rules << EndingRule.new('mming', 4, 44.3)
    @rules << EndingRule.new('mmings', 5, 44.3)
    @rules << EndingRule.new('rming', 3, 44.2)
    @rules << EndingRule.new('lming', 3, 44.1)

    # plural change - this differs from Perl v1.03
    @rules << ConcatenatingEndingRule.new('ming', 3, 44, 'e')
    @rules << ConcatenatingEndingRule.new('mings', 4, 44, 'e')

    @rules << EndingRule.new('nging', 3, 45.2)
    @rules << EndingRule.new('ngings', 4, 45.2)
    @rules << EndingRule.new('gging', 4, 45.1)
    @rules << EndingRule.new('ggings', 5, 45.1)
    @rules << EndingRule.new('ging', 3, 45)
    @rules << EndingRule.new('gings', 4, 45)
    @rules << EndingRule.new('aning', 3, 46.6)
    @rules << EndingRule.new('ening', 3, 46.5)
    @rules << EndingRule.new('gning', 3, 46.4)
    @rules << EndingRule.new('nning', 4, 46.3)
    @rules << EndingRule.new('oning', 3, 46.2)
    @rules << EndingRule.new('rning', 3, 46.1)
    @rules << ConcatenatingEndingRule.new('ning', 3, 46, 'e')

    # plural change - this differs from Perl v1.03
    @rules << EndingRule.new('sting', 3, 47)
    @rules << EndingRule.new('stings', 4, 47)
    @rules << EndingRule.new('eting', 3, 48.4)
    @rules << EndingRule.new('etings', 4, 48.4)

    @rules << EndingRule.new('pting', 3, 48.3)
    @rules << EndingRule.new('nting', 3, 48.2)
    @rules << EndingRule.new('ntings', 4, 48.2)
    @rules << EndingRule.new('cting', 3, 48.1)
    @rules << ConcatenatingEndingRule.new('ting', 3, 48, 'e')
    @rules << ConcatenatingEndingRule.new('tings', 4, 48, 'e')

    @rules << EndingRule.new('ssed', 2, 49)
    @rules << EndingRule.new('les', 1, 50)
    @rules << EndingRule.new('tes', 1, 51)
    @rules << EndingRule.new('zed', 1, 52)
    @rules << EndingRule.new('lled', 2, 53)

    # plural change - this differs from Perl v1.03
    @rules << ConcatenatingEndingRule.new('iring', 3, 54.4, 'e')
    @rules << ConcatenatingEndingRule.new('irings', 4, 54.4, 'e')
    @rules << ConcatenatingEndingRule.new('uring', 3, 54.3, 'e')
    @rules << ConcatenatingEndingRule.new('urings', 4, 54.3, 'e')
    @rules << ConcatenatingEndingRule.new('ncing', 3, 54.2, 'e')
    @rules << ConcatenatingEndingRule.new('ncings', 4, 54.2, 'e')

    @rules << ConcatenatingEndingRule.new('zing', 3, 54.1, 'e')

    # plural change - this differs from Perl v1.03
    @rules << ConcatenatingEndingRule.new('sing', 3, 54, 'e')
    @rules << ConcatenatingEndingRule.new('sings', 4, 54, 'e')

    @rules << EndingRule.new('lling', 3, 55)
    @rules << ConcatenatingEndingRule.new('ied', 3, 56, 'y')
    @rules << ConcatenatingEndingRule.new('ating', 3, 57, 'e')

    # plural change - this differs from Perl v1.03
    @rules << ConcatenatingEndingRule.new('dying', 4, 58.2, 'ie')   # added by JMA
    @rules << ConcatenatingEndingRule.new('tying', 4, 58.2, 'ie')   # added by JMA
    @rules << EndingRule.new('thing', 0, 58.1)
    @rules << EndingRule.new('things', 1, 58.1)
    @rules << CustomRule.new(/.*\w\wings?$/, 3, 58)

    @rules << ConcatenatingEndingRule.new('ies', 3, 59, 'y')
    @rules << ConcatenatingEndingRule.new('lves', 3, 60.1, 'f')
    @rules << EndingRule.new('ves', 1, 60)
    @rules << EndingRule.new('aped', 1, 61.3)
    @rules << EndingRule.new('uded', 1, 61.2)
    @rules << EndingRule.new('oded', 1, 61.1)
    @rules << EndingRule.new('ated', 1, 61)
    @rules << CustomRule.new(/.*\w\weds?$/, 2, 62)
    @rules << EndingRule.new('pes', 1, 63.8)
    @rules << EndingRule.new('mes', 1, 63.7)
    @rules << EndingRule.new('ones', 1, 63.6)
    @rules << EndingRule.new('izes', 1, 63.5)
    @rules << EndingRule.new('ures', 1, 63.4)
    @rules << EndingRule.new('ines', 1, 63.3)
    @rules << EndingRule.new('ides', 1, 63.2)
    @rules << EndingRule.new('ges', 1, 63.1)
    @rules << EndingRule.new('es', 2, 63)
    @rules << ConcatenatingEndingRule.new('is', 2, 64, 'e')
    @rules << EndingRule.new('ous', 0, 65)
    @rules << EndingRule.new('ums', 0, 66)
    @rules << EndingRule.new('us', 0, 67)
    @rules << EndingRule.new('s', 1, 68)

    @rules.each { |r| r.freeze }

    nil
  end

  def problem_word?(word)
    ['is', 'as', 'this', 'has', 'was', 'during', 'menses'].include?(word)
  end

end

class DefaultUEAStemmer < UEAStemmer
  include Singleton
end