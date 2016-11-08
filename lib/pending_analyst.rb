require_relative 'statistics'
require 'date'

class PendingAnalyst
  
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

  def merchants_with_pending_invoices
    pending_invoices.map { |pender| pender.merchant }.uniq
  end

  def pending_invoices
    invoices.find_all { |invoice| pending?(invoice) }
  end

  def pending?(invoice)
    invoice.transactions.all? { |transaction| transaction.result == "failed" }
  end

end
