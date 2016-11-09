require_relative 'statistics'
require_relative 'pending_analyst'
require 'date'

class ItemRevenueAnalyst

  include Statistics

  extend Forwardable

  def_delegators :@pending_analyst, 
                 :merchants_with_pending_invoices,
                 :pending_invoices, 
                 :pending?

  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine    = sales_engine
    @pending_analyst = PendingAnalyst.new(sales_engine)
  end

  def items
    sales_engine.all_items
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
