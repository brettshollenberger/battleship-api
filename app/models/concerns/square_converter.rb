module SquareConverter
  def letter_to_integer_map
    Hash[*("A".."Z").zip(1..26).flatten]
  end

  def letter_to_integer(arg)
    letter_to_integer_map[arg]
  end

  def integer_to_letter_map
    letter_to_integer_map.invert
  end

  def integer_to_letter(arg)
    integer_to_letter_map[arg]
  end
end
