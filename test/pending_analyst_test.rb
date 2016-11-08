require_relative 'test_helper'
require_relative '../lib/pending_analyst'
require_relative '../lib/sales_engine'

class PendingAnalystTest < Minitest::Test
  attr_reader :pending_analyst, :pending_analyst2
  def setup
    @sales_engine = SalesEngine.from_csv({
      :items          => "./data/test_items.csv",
      :merchants      => "./data/test_merchants.csv",
      :invoices       => "./data/test_invoices.csv",
      :invoice_items  => "./data/test_invoice_items.csv",
      :customers      => "./data/test_customers.csv",
      :transactions   => "./data/test_transactions.csv"
    })
    @sales_engine_mock = Minitest::Mock.new
    @pending_analyst     = PendingAnalyst.new(@sales_engine)
    @pending_analyst2    = PendingAnalyst.new(@sales_engine_mock)
  end

  def test_it_exists
    assert pending_analyst
  end

  def test_it_takes_sales_engine_instance_as_argument
    assert PendingAnalyst.new(@sales_engine_mock)
  end

  def test_merchants_calls_sales_engine
    pending_analyst2.sales_engine.expect(:all_merchants, nil, [])
    pending_analyst2.merchants
    pending_analyst2.sales_engine.verify
  end

  def test_invoices_calls_sales_engine
    pending_analyst2.sales_engine.expect(:all_invoices, nil, [])
    pending_analyst2.invoices
    pending_analyst2.sales_engine.verify
  end

  def test_merchants_with_pending_invoices
    assert_equal Merchant, pending_analyst.merchants_with_pending_invoices.first.class
  end

  def test_pending_invoices
    assert pending_analyst.pending_invoices.all? { |invoice| invoice.class == Invoice}
  end

end
