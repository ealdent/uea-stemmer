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

require 'uea-stemmer/string_helpers'

class UEAStemmer
  class Rule
    include StringHelpers

    attr_reader :pattern, :suffix_size, :rule_num

    def initialize(pattern, suffix_size, rule_num)
      @pattern = pattern.dup.freeze
      @suffix_size = suffix_size
      @rule_num = rule_num
    end

    def handle(word)
      [remove_suffix(word, @suffix_size), @rule_num, self] if word =~ @pattern
    end

    def to_s
      "rule ##{@rule_num} (remove #{@suffix_size} letters from the end of the word when it matches pattern #{@pattern})"
    end
  end

  class EndingRule < Rule
    attr_reader :original_pattern

    def initialize(pattern, suffix_size, rule_num)
      super(/^.*#{pattern}$/, suffix_size, rule_num)
      @original_pattern = pattern.dup.freeze
    end

    def to_s
      "rule ##{@rule_num} (remove -#{@original_pattern[@original_pattern.size - @suffix_size, @suffix_size]} when the word ends in -#{@original_pattern})"
    end
  end

  class ConcatenatingEndingRule < EndingRule
    attr_reader :new_suffix

    def initialize(pattern, suffix_size, rule_num, new_suffix)
      super(pattern, suffix_size, rule_num)
      @new_suffix = new_suffix.dup.freeze
    end

    def handle(word)
      [remove_suffix(word, @suffix_size) + @new_suffix, @rule_num, self] if word =~ @pattern
    end

    def to_s
      "rule ##{@rule_num} (remove -#{@original_pattern[@original_pattern.size - @suffix_size, @suffix_size]} and add -#{new_suffix} when the word ends in -#{@original_pattern})"
    end
  end

  class NonExhaustiveEndingRule < EndingRule
    def handle(word)
      super(word) if word != @original_pattern
    end

    def to_s
      "rule ##{@rule_num} (remove -#{@original_pattern[@original_pattern.size - @suffix_size, @suffix_size]} when the word ends in -#{@original_pattern} unless the word is #{@original_pattern})"
    end
  end

  class CustomRule < Rule
    def initialize(pattern, suffix_size, rule_num)
      super(pattern, suffix_size, rule_num)
    end

    def handle(word)
      [stem_with_duplicate_character_check(word), @rule_num, self] if word =~ @pattern
    end

    protected

    def stem_with_duplicate_character_check(word)
      new_suffix_size = ends_with?(word, 's') ? @suffix_size + 1 : @suffix_size
      stemmed_word = remove_suffix(word, new_suffix_size)
      stemmed_word.chop! if stemmed_word =~ /.*(\w)\1$/
      stemmed_word
    end
  end
end