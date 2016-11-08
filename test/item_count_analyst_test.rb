require_relative 'test_helper'
require_relative '../lib/item_count_analyst'
require_relative '../lib/sales_engine'

class ItemCountAnalystTest < Minitest::Test
  attr_reader :item_count_analyst, :item_count_analyst2
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
    @item_count_analyst     = ItemCountAnalyst.new(@sales_engine)
    @item_count_analyst2    = ItemCountAnalyst.new(@sales_engine_mock)
  end

  def test_it_exists
    assert item_count_analyst
  end

  def test_it_takes_sales_engine_instance_as_argument
    assert ItemCountAnalyst.new(@sales_engine_mock)
  end

  def test_items_calls_sales_engine
    item_count_analyst2.sales_engine.expect(:all_items, nil, [])
    item_count_analyst2.items
    item_count_analyst2.sales_engine.verify
  end

  def test_merchants_calls_sales_engine
    item_count_analyst2.sales_engine.expect(:all_merchants, nil, [])
    item_count_analyst2.merchants
    item_count_analyst2.sales_engine.verify
  end

  def test_average_items_per_merchant_returns_a_float
    assert Float, item_count_analyst.average_items_per_merchant.class
    assert_equal 2.13, item_count_analyst.average_items_per_merchant
  end

  def test_it_calls_sales_engine_object
    assert SalesEngine, item_count_analyst.sales_engine.class
  end

  def test_avg_items_per_merch_std_dev_returns_std_dev
    assert_equal 1.89, item_count_analyst.average_items_per_merchant_standard_deviation
  end

  def test_it_finds_merchants_with_items_greater_than_one_std_dev
    high_rollers = item_count_analyst.merchants_with_high_item_count
    assert high_rollers.all?{|merchant| merchant.class == Merchant}
    assert high_rollers.all?{|merchant| merchant.items.count > 4.21}
    assert_equal 4, high_rollers.count
  end
  
end
