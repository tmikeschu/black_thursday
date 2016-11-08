require_relative 'statistics'
require 'date'

class ItemCountAnalyst
  
  include Statistics

  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine  = sales_engine
  end

  def items
    sales_engine.all_items
  end

  def merchants
    sales_engine.all_merchants
  end

  def average_items_per_merchant
    average(merchants.map{ |merchant| merchant.items.count })
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(merchants.map {|merchant| merchant.items.count})
  end

  def merchants_with_high_item_count
    mean       = average_items_per_merchant
    std_dev    = average_items_per_merchant_standard_deviation
    threshhold = mean + std_dev
    merchants.find_all { |merchant| merchant.items.count > threshhold }
  end

end
