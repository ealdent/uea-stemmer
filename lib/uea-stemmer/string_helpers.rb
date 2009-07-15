module StringHelpers
  def remove_suffix(word, suffix_size)
    word[0, word.size - suffix_size]
  end

  def ends_with?(word, suffix)
    !!(word =~ /#{suffix}$/)
  end
end