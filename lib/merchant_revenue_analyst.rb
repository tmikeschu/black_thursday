require_relative 'statistics'
require 'date'

class MerchantRevenueAnalyst
  
  include Statistics

  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine  = sales_engine
  end

  def merchants
    sales_engine.all_merchants
  end

  def invoices
    sales_engine.all_invoices
  end 

  def total_revenue_by_date(date)
    total = invoices_total(invoices_on_date(date))
    return total.round(2) if total
    0
  end

  def invoices_on_date(date)
    date = date.strftime('%F')
    invoices.find_all do |invoice|
      invoice.created_at.strftime('%F') == date
    end
  end

  def top_revenue_earners(number = 20)
    merchants_ranked_by_revenue.first(number)
  end

  def merchants_ranked_by_revenue
    sorted = merchants_and_invoices.keys.sort_by do |merchant|
      invoices_total(merchants_and_invoices[merchant])
    end.reverse
    sorted.map { |merchant_id| sales_engine.merchants.find_by_id(merchant_id) }
  end

  def invoices_total(invoices)
    invoices.map { |invoice| invoice.total }.reduce(:+)
  end

  def merchants_and_invoices
    invoices.group_by { |invoice| invoice.merchant_id }
  end

  def revenue_by_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    invoices_total(merchant.invoices).round(2)
  end

end
