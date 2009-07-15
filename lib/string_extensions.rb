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

class String
  def ends_with?(suffix)
    !!(self =~ /#{suffix}$/)
  end

  def remove_suffix(suffix_size)
    self[0, size - suffix_size]
  end

  def uea_stem
    DefaultUEAStemmer.instance.stem(self)
  end

  def stem
    uea_stem
  end

  def uea_stem_with_rule
    DefaultUEAStemmer.instance.stem_with_rule(self)
  end

  def stem_with_rule
    uea_stem_with_rule
  end
end
