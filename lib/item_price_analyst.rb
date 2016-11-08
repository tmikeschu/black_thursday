require_relative 'statistics'
require 'date'

class ItemPriceAnalyst
  
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

  def average_item_price_for_merchant(id)
    merch_items = sales_engine.merchants.find_by_id(id).items
    return 0 if merch_items.empty?
    average(merch_items.map { |row| row.unit_price })
  end

  def average_average_price_per_merchant
    averages = merchants.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    average(averages)
  end

  def golden_items
    mean       = average_item_price
    std_dev    = item_price_standard_deviation
    threshhold = mean + (std_dev * 2)
    items.find_all { |item| item.unit_price > threshhold }
  end

  def average_item_price
    average(items.map { |item| item.unit_price })
  end

  def item_price_standard_deviation
    standard_deviation(items.map { |item| item.unit_price })
  end

end
