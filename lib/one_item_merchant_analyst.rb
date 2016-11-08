require_relative 'statistics'
require 'date'

class OneItemMerchantAnalyst
  
  include Statistics

  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine  = sales_engine
  end

  def merchants
    sales_engine.all_merchants
  end

  def items
    sales_engine.all_items
  end 

  def merchants_with_only_one_item
    merchants = items.group_by { |item| item.merchant_id }
    ones = merchants.keys.find_all { |id| merchants[id].count == 1}
    ones.map { |id| sales_engine.merchants.find_by_id(id) }
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_by_registration_month[month].find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def merchants_by_registration_month
    merchants.group_by do |merchant|
      Date::MONTHNAMES[merchant.created_at.month]
    end
  end

end
