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
  def_delegators :item_count_analyst,
                 :average_items_per_merchant,
                 :average_items_per_merchant_standard_deviation,
                 :merchants_with_high_item_count

  def_delegators :item_price_analyst,
                 :average_item_price_for_merchant,
                 :average_average_price_per_merchant,
                 :golden_items,
                 :average_item_price,
                 :item_price_standard_deviation
 
  def_delegators :invoice_count_analyst,
                 :average_invoices_per_merchant,
                 :average_invoices_per_merchant_standard_deviation,
                 :top_merchants_by_invoice_count,
                 :bottom_merchants_by_invoice_count,
                 :top_days_by_invoice_count,
                 :invoices_by_day,
                 :invoice_days,
                 :average_invoices_per_day,
                 :average_invoices_per_day_standard_deviation,
                 :invoice_status,
                 :all_invoices_by_status

  def_delegators :merchant_revenue_analyst,
                 :total_revenue_by_date,
                 :invoices_on_date,
                 :top_revenue_earners,
                 :merchants_ranked_by_revenue,
                 :invoices_total,
                 :merchants_and_invoices,
                 :revenue_by_merchant

  def_delegators :pending_analyst,
                 :merchants_with_pending_invoices,
                 :pending_invoices,
                 :pending?

  def_delegators :one_item_merchant_analyst,
                 :merchants_with_only_one_item,
                 :merchants_with_only_one_item_registered_in_month,
                 :merchants_by_registration_month

  def_delegators :item_revenue_analyst,
                 :most_sold_item_for_merchant,
                 :most_sold_items,
                 :item_quantities,
                 :item_quantities_of_merchant,
                 :all_invoice_items,
                 :complete_invoices,
                 :best_item_for_merchant,
                 :item_revenues_of_merchant,
                 :item_revenues,
                 :best_items,
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

