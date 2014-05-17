module SquareSubset
  def contiguous?
    numerically_sequential? && same?(:y) || 
      alphabetically_sequential? && same?(:x)
  end

  def same?(key)
    map { |square| square.send(key) }.uniq.length == 1
  end

  def was
    owner.id ? Square.where(ship_id: owner.id) : self
  end

private
  def numerically_sequential?
    sequential? map { |sq| sq.x.to_i }
  end

  def alphabetically_sequential?
    sequential? map { |sq| letter_to_integer[sq.y] }
  end

  def sequential?(nums)
    nums.sort.inject { |p, n| n == p + 1 ? n : -1 } != -1
  end

  def letter_to_integer
    Hash[*("A".."Z").zip(1..26).flatten]
  end

  def owner
    proxy_association.owner
  end
end
