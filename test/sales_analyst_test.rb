require_relative 'test_helper'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'

class SalesAnalystTest < Minitest::Test
  attr_reader :sales_analyst, :sales_analyst2
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
    @sales_analyst     = SalesAnalyst.new(@sales_engine)
    @sales_analyst2    = SalesAnalyst.new(@sales_engine_mock)
  end

  def test_it_exists
    assert sales_analyst
  end

  def test_it_takes_sales_engine_instance_as_argument
    assert SalesAnalyst.new(@sales_engine_mock)
  end

  def test_it_calls_sales_engine_object
    assert SalesEngine, sales_analyst.sales_engine.class
  end

  def test_average_items_per_merchant_delegates_to_item_count_analyst
    assert @sales_analyst.average_items_per_merchant
  end

  def test_average_item_price_for_merchant_delegates_to_item_price_analyst
    assert @sales_analyst.average_item_price_for_merchant(3)
  end

  def test_average_invoices_per_merchant_delegates_to_invoice_count_analyst
    assert @sales_analyst.average_invoices_per_merchant
  end

  def test_total_revenue_by_date_delegates_to_merchant_revenue_analyst
    date = Time.parse("2012-02-26")
    assert @sales_analyst.total_revenue_by_date(date)
  end

  def test_merchants_with_only_one_item_delegates_to_one_item_merchant_analyst
    assert sales_analyst.merchants_with_only_one_item
  end

  def test_most_sold_item_for_merchant_delegates_to_item_revenue_analyst
    assert sales_analyst.most_sold_item_for_merchant(7)
  end

end
