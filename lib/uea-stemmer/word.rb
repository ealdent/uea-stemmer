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
  class Word
    attr_reader :word, :rule_num, :rule

    def initialize(word, rule_num, rule = nil)
      @word = word.dup.freeze
      @rule_num = rule_num
      @rule = rule
    end

    def to_s
      if @rule_num > 0
        "#{@word} (Rule ##{@rule_num} #{@rule})"
      else
        "#{@word} (No rule)"
      end
    end
  end
end
