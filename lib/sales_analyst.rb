require_relative 'item_count_analyst'
require_relative 'item_price_analyst'
require_relative 'invoice_count_analyst'
require_relative 'merchant_revenue_analyst'
require_relative 'pending_analyst'
require_relative 'one_item_merchant_analyst'
require_relative 'item_revenue_analyst'
require 'date'

class SalesAnalyst

  extend Forwardable
  def_delegator :item_count_analyst,
                :average_items_per_merchant
  def_delegator :item_count_analyst,
                :average_items_per_merchant_standard_deviation
  def_delegator :item_count_analyst,
                :merchants_with_high_item_count

  def_delegator :item_price_analyst,
                :average_item_price_for_merchant
  def_delegator :item_price_analyst,
                :average_average_price_per_merchant
  def_delegator :item_price_analyst,
                :golden_items
  def_delegator :item_price_analyst,
                :average_item_price
  def_delegator :item_price_analyst,
                :item_price_standard_deviation

  def_delegator :invoice_count_analyst,
                :average_invoices_per_merchant
  def_delegator :invoice_count_analyst,
                :average_invoices_per_merchant_standard_deviation
  def_delegator :invoice_count_analyst,
                :top_merchants_by_invoice_count
  def_delegator :invoice_count_analyst,
                :bottom_merchants_by_invoice_count
  def_delegator :invoice_count_analyst,
                :top_days_by_invoice_count
  def_delegator :invoice_count_analyst,
                :invoices_by_day
  def_delegator :invoice_count_analyst,
                :invoice_days
  def_delegator :invoice_count_analyst,
                :average_invoices_per_day
  def_delegator :invoice_count_analyst,
                :average_invoices_per_day_standard_deviation
  def_delegator :invoice_count_analyst,
                :invoice_status
  def_delegator :invoice_count_analyst,
                :all_invoices_by_status

  def_delegator :merchant_revenue_analyst,
                :total_revenue_by_date
  def_delegator :merchant_revenue_analyst,
                :invoices_on_date
  def_delegator :merchant_revenue_analyst,
                :top_revenue_earners
  def_delegator :merchant_revenue_analyst,
                :merchants_ranked_by_revenue
  def_delegator :merchant_revenue_analyst,
                :invoices_total
  def_delegator :merchant_revenue_analyst,
                :merchants_and_invoices
  def_delegator :merchant_revenue_analyst,
                :revenue_by_merchant

  def_delegator :pending_analyst,
                :merchants_with_pending_invoices
  def_delegator :pending_analyst,
                :pending_invoices
  def_delegator :pending_analyst,
                :pending?

  def_delegator :one_item_merchant_analyst,
                :merchants_with_only_one_item
  def_delegator :one_item_merchant_analyst,
                :merchants_with_only_one_item_registered_in_month
  def_delegator :one_item_merchant_analyst,
                :merchants_by_registration_month

  def_delegator :item_revenue_analyst,
                :most_sold_item_for_merchant
  def_delegator :item_revenue_analyst,
                :most_sold_items
  def_delegator :item_revenue_analyst,
                :item_quantities
  def_delegator :item_revenue_analyst,
                :item_quantities_of_merchant
  def_delegator :item_revenue_analyst,
                :all_invoice_items
  def_delegator :item_revenue_analyst,
                :complete_invoices
  def_delegator :item_revenue_analyst,
                :best_item_for_merchant
  def_delegator :item_revenue_analyst,
                :item_revenues_of_merchant
  def_delegator :item_revenue_analyst,
                :item_revenues
  def_delegator :item_revenue_analyst,
                :best_items
  def_delegator :item_revenue_analyst,
                :top_items_by_revenue

  attr_reader :sales_engine, :item_count_analyst,
              :item_price_analyst, :invoice_count_analyst,
              :merchant_revenue_analyst, :pending_analyst,
              :one_item_merchant_analyst, :item_revenue_analyst

  def initialize(sales_engine)
    @sales_engine              = sales_engine
    @item_count_analyst        = ItemCountAnalyst.new(sales_engine)
    @item_price_analyst        = ItemPriceAnalyst.new(sales_engine)
    @invoice_count_analyst     = InvoiceCountAnalyst.new(sales_engine)
    @merchant_revenue_analyst  = MerchantRevenueAnalyst.new(sales_engine)
    @pending_analyst           = PendingAnalyst.new(sales_engine)
    @one_item_merchant_analyst = OneItemMerchantAnalyst.new(sales_engine)
    @item_revenue_analyst      = ItemRevenueAnalyst.new(sales_engine)
  end

end

