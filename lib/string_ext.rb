class String  
  
  # Truncates a string 
  def truncate(length = 30, end_string = '…')
    return self if self == nil
    words = self.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end