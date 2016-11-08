require_relative 'statistics'
require 'date'

class InvoiceCountAnalyst

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

  def invoices
    sales_engine.all_invoices
  end

  def average_invoices_per_merchant
    average(merchants.map { |merchant| merchant.invoices.count })
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(merchants.map { |merchant| merchant.invoices.count })
  end

  def top_merchants_by_invoice_count
    mean       = average_invoices_per_merchant
    std_dev    = average_invoices_per_merchant_standard_deviation
    threshhold = mean + (std_dev * 2)
    merchants.find_all { |merchant| merchant.invoices.count > threshhold }
  end

  def bottom_merchants_by_invoice_count
    mean       = average_invoices_per_merchant
    std_dev    = average_invoices_per_merchant_standard_deviation
    threshhold = mean - (std_dev * 2)
    merchants.find_all { |merchant| merchant.invoices.count < threshhold }
  end

  def top_days_by_invoice_count
    mean       = average_invoices_per_day
    std_dev    = average_invoices_per_day_standard_deviation
    threshhold = mean + std_dev
    invoices_by_day.keys.find_all { |day| invoices_by_day[day] > threshhold }
  end

  def invoices_by_day
    invoice_days.reduce ({}) do |result, day|
      result[day]  = 0 if result[day].nil?
      result[day] += 1
      result
    end
  end

  def invoice_days
    invoices.map { |invoice| Date::DAYNAMES[invoice.created_at.wday] }
  end

  def average_invoices_per_day
    average(invoices_by_day.values)
  end

  def average_invoices_per_day_standard_deviation
    standard_deviation(invoices_by_day.values)
  end

  def invoice_status(invoice_status)
    status = all_invoices_by_status(invoice_status).count.to_f
    count  = invoices.count.to_f
    ((status / count) * 100).round(2)
  end

  def all_invoices_by_status(invoice_status)
    invoices.find_all { |row| row.status.to_sym == invoice_status.to_sym }
  end

end
