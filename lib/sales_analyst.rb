class SalesAnalyst

  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def items
    sales_engine.all_items
  end

  def merchants
    sales_engine.all_merchants
  end

  def average_items_per_merchant
    (items.count / merchants.count.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    numerator   = items_per_merchant_std_dev_numerator
    denominator = items_per_merchant_std_dev_denominator
    Math.sqrt(numerator / denominator).round(2)
  end

  def items_per_merchant_std_dev_numerator
    merchants.map do |merchant|
      ((merchant.items.count - average_items_per_merchant) ** 2).to_f
    end.reduce(:+).to_f
  end

  def items_per_merchant_std_dev_denominator
    (merchants.count - 1).to_f
  end

  def merchants_with_high_item_count
    mean    = average_items_per_merchant
    std_dev = average_items_per_merchant_standard_deviation
    merchants.find_all do |merchant|
      merchant.items.count > (mean + std_dev)
    end
  end

  def average_item_price_for_merchant(id)
    merch_items  = sales_engine.merchants.find_by_id(id).items
    return 0 if merch_items.empty?
    prices = merch_items.map do |row|
      row.unit_price
    end.reduce(:+) / merch_items.count
    prices.round(2)
  end

  def average_average_price_per_merchant
    sum = merchants.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end.reduce(:+)
    (sum / merchants.count).round(2)
  end

  def golden_items
    mean    = average_item_price
    std_dev = item_price_standard_deviation
    items.find_all do |item|
      item.unit_price > (mean + (std_dev * 2))
    end
  end

  def average_item_price
    sum   = items.map { |item| item.unit_price }.reduce(:+)
    sum / items.count
  end

  def item_price_standard_deviation
    numerator   = item_price_std_dev_numerator
    denominator = item_price_std_dev_denominator
    Math.sqrt(numerator / denominator).round(2)
  end

  def item_price_std_dev_numerator
    items.map do |item|
      (item.unit_price - average_item_price) ** 2
    end.reduce(:+)
  end

  def item_price_std_dev_denominator
    sales_engine.items.all.count - 1
  end

end
