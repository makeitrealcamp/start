class SHA1
  def self.encode(text)
    Digest::SHA1.hexdigest(text)
  end

  def self.encode_array(arr)
    arr.map { |text| encode(text) }
  end
end
