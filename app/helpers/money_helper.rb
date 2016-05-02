module MoneyHelper
  def median(array)
    array.sort!
    elements = array.count
    center =  elements/2
    elements.even? ? (array[center] + array[center+1])/2 : array[center]
  end
end
