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

class UEAStemmer
  class Rule
    attr_reader :pattern, :suffix_size, :rule_num

    def initialize(pattern, suffix_size, rule_num)
      @pattern = pattern.dup.freeze
      @suffix_size = suffix_size
      @rule_num = rule_num
    end

    def handle(word)
      [word.remove_suffix(@suffix_size), @rule_num, self] if word =~ @pattern
    end

    def to_s
      "rule ##{@rule_num} (remove #{@suffix_size} letters from the end of the word when it matches pattern #{@pattern})"
    end
  end

  class EndingRule < Rule
    def handle(word)
      [word.remove_suffix(@suffix_size), @rule_num, self] if word.ends_with?(@pattern)
    end

    def to_s
      "rule ##{@rule_num} (remove -#{@pattern[@pattern.size - @suffix_size, @suffix_size]} when the word ends in -#{@pattern})"
    end
  end

  class ConcatenatingEndingRule < EndingRule
    attr_reader :new_suffix

    def initialize(pattern, suffix_size, rule_num, new_suffix)
      super(pattern, suffix_size, rule_num)
      @new_suffix = new_suffix.dup.freeze
    end

    def handle(word)
      [word.remove_suffix(@suffix_size) + @new_suffix, @rule_num, self] if word.ends_with?(@pattern)
    end

    def to_s
      "rule ##{@rule_num} (remove -#{@pattern[@pattern.size - @suffix_size, @suffix_size]} and add -#{new_suffix} when the word ends in -#{@pattern})"
    end
  end

  class NonExhaustiveEndingRule < EndingRule
    def handle(word)
      super(word) if word != @pattern
    end

    def to_s
      "rule ##{@rule_num} (remove -#{@pattern[@pattern.size - @suffix_size, @suffix_size]} when the word ends in -#{@pattern} unless the word is #{@pattern})"
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
      new_suffix_size = word.ends_with?('s') ? @suffix_size + 1 : @suffix_size
      stemmed_word = word.remove_suffix(new_suffix_size)
      stemmed_word.chop! if stemmed_word =~ /.*(\w)\1$/
      stemmed_word
    end
  end
end