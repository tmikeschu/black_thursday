require_relative 'statistics'
require_relative 'item_count_analyst'
require_relative 'item_price_analyst'
require_relative 'invoice_count_analyst'
require_relative 'merchant_revenue_analyst'
require_relative 'pending_analyst'
require 'date'

class SalesAnalyst
  
  include Statistics

  extend Forwardable
  def_delegator :item_count_analyst, :average_items_per_merchant
  def_delegator :item_count_analyst, :average_items_per_merchant_standard_deviation
  def_delegator :item_count_analyst, :merchants_with_high_item_count

  def_delegator :item_price_analyst, :average_item_price_for_merchant
  def_delegator :item_price_analyst, :average_average_price_per_merchant
  def_delegator :item_price_analyst, :golden_items
  def_delegator :item_price_analyst, :average_item_price
  def_delegator :item_price_analyst, :item_price_standard_deviation

  def_delegator :invoice_count_analyst, :average_invoices_per_merchant
  def_delegator :invoice_count_analyst, :average_invoices_per_merchant_standard_deviation
  def_delegator :invoice_count_analyst, :top_merchants_by_invoice_count
  def_delegator :invoice_count_analyst, :bottom_merchants_by_invoice_count
  def_delegator :invoice_count_analyst, :top_days_by_invoice_count
  def_delegator :invoice_count_analyst, :invoices_by_day
  def_delegator :invoice_count_analyst, :invoice_days
  def_delegator :invoice_count_analyst, :average_invoices_per_day
  def_delegator :invoice_count_analyst, :average_invoices_per_day_standard_deviation
  def_delegator :invoice_count_analyst, :invoice_status
  def_delegator :invoice_count_analyst, :all_invoices_by_status

  def_delegator :merchant_revenue_analyst, :total_revenue_by_date
  def_delegator :merchant_revenue_analyst, :invoices_on_date
  def_delegator :merchant_revenue_analyst, :top_revenue_earners
  def_delegator :merchant_revenue_analyst, :merchants_ranked_by_revenue
  def_delegator :merchant_revenue_analyst, :invoices_total
  def_delegator :merchant_revenue_analyst, :merchants_and_invoices
  def_delegator :merchant_revenue_analyst, :revenue_by_merchant
  
  def_delegator :pending_analyst, :merchants_with_pending_invoices
  def_delegator :pending_analyst, :pending_invoices
  def_delegator :pending_analyst, :pending?

  attr_reader :sales_engine, :item_count_analyst, :item_price_analyst,
              :invoice_count_analyst, :merchant_revenue_analyst, :pending_analyst

  def initialize(sales_engine)
    @sales_engine  = sales_engine
    @item_count_analyst = ItemCountAnalyst.new(sales_engine)
    @item_price_analyst = ItemPriceAnalyst.new(sales_engine)
    @invoice_count_analyst = InvoiceCountAnalyst.new(sales_engine)
    @merchant_revenue_analyst = MerchantRevenueAnalyst.new(sales_engine)
    @pending_analyst = PendingAnalyst.new(sales_engine)
  end

  def items
    sales_engine.all_items
  end

  def merchants
    sales_engine.all_merchants
  end

  def invoices
    sales_engine.all_invoices
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

  def most_sold_item_for_merchant(merchant_id)
    items_and_count  = item_quantities_of_merchant(merchant_id)
    max              = items_and_count.values.max
    items            = items_and_count.keys
    items.find_all { |item| items_and_count[item] == max }
  end

  def most_sold_items
    items_and_count  = item_quantities
    max              = items_and_count.values.max
    items            = items_and_count.keys
    items.find_all { |item| items_and_count[item] == max }
  end

  def item_quantities
    invoices = complete_invoices(sales_engine.all_invoices)
    all_invoice_items(invoices).reduce ({}) do |result, invoice_item|
      result[invoice_item.item]  = 0 unless result[invoice_item.item_id]
      result[invoice_item.item] += invoice_item.quantity
      result
    end
  end

  def item_quantities_of_merchant(merchant_id)
    invoices = complete_invoices(sales_engine.find_invoices(merchant_id))
    all_invoice_items(invoices).reduce ({}) do |result, invoice_item|
      result[invoice_item.item]  = 0 unless result[invoice_item.item_id]
      result[invoice_item.item] += invoice_item.quantity
      result
    end
  end

  def all_invoice_items(invoices)
    invoices.flat_map { |invoice| invoice.invoice_items }
  end

  def complete_invoices(invoices)
    invoices.reject { |invoice| pending?(invoice) }
  end

  def best_item_for_merchant(merchant_id)
    items_and_revenues = item_revenues_of_merchant(merchant_id)
    items              = items_and_revenues.keys
    item = items.max_by { |item| items_and_revenues[item] }
    return [] unless item
    sales_engine.items.find_by_id(item)
  end

  def item_revenues_of_merchant(merchant_id)
    invoices = complete_invoices(sales_engine.find_invoices(merchant_id))
    all_invoice_items(invoices).reduce ({}) do |result, item|
      result[item.item_id]  = 0 unless result[item.item_id]
      result[item.item_id] += item.quantity*item.unit_price
      result
    end
  end

  def item_revenues
    invoices = complete_invoices(sales_engine.all_invoices)
    all_invoice_items(invoices).reduce ({}) do |result, item|
      result[item.item_id]  = 0 unless result[item.item_id]
      result[item.item_id] += item.quantity*item.unit_price
      result
    end
  end

  def best_items(number = 5)
    top_items_by_revenue(item_revenues).first(number).map do |id|
      item = sales_engine.items.find_by_id(id)
      [
        item.name,
        item_revenues[id].to_f,
        item.merchant.name
      ] if item
    end
  end

  def top_items_by_revenue(items_and_revenues)
    items_and_revenues.keys.sort_by do |item|
      items_and_revenues[item]
    end.reverse
  end

end
