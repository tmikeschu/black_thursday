require_relative 'test_helper'
require_relative '../lib/item_price_analyst'
require_relative '../lib/sales_engine'

class ItemPriceAnalystTest < Minitest::Test
  attr_reader :item_price_analyst, :item_price_analyst2
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
    @item_price_analyst     = ItemPriceAnalyst.new(@sales_engine)
    @item_price_analyst2    = ItemPriceAnalyst.new(@sales_engine_mock)
  end

  def test_it_exists
    assert item_price_analyst
  end

  def test_it_takes_sales_engine_instance_as_argument
    assert ItemPriceAnalyst.new(@sales_engine_mock)
  end

  def test_items_calls_sales_engine
    item_price_analyst2.sales_engine.expect(:all_items, nil, [])
    item_price_analyst2.items
    item_price_analyst2.sales_engine.verify
  end

  def test_merchants_calls_sales_engine
    item_price_analyst2.sales_engine.expect(:all_merchants, nil, [])
    item_price_analyst2.merchants
    item_price_analyst2.sales_engine.verify
  end

  def test_average_item_price_per_merchant_returns_a_Big_Decimal
    assert BigDecimal, item_price_analyst.average_item_price_for_merchant(3).class
  end

  def test_it_calculates_the_average_item_price_per_merchant
    result = item_price_analyst.average_item_price_for_merchant(3)
    assert_equal 15.16, result.to_f
  end

  def test_average_average_price_per_merchant_returns_a_Big_Decimal
    assert BigDecimal, item_price_analyst.average_average_price_per_merchant
  end

  def test_it_finds_the_average_of_average_price_per_merchant
    assert_equal BigDecimal.new('0.10042E3'), item_price_analyst.average_average_price_per_merchant
  end

  def test_golden_items_returns_items_with_price_greater_than_2_std_devs_above_avg_price
    gold_items = item_price_analyst.golden_items
    assert gold_items.all?{|item| item.unit_price > 6.42}
    assert gold_items.all?{|item| item.class == Item}
    assert_equal 1, gold_items.count
  end

end
