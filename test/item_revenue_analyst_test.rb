require_relative 'test_helper'
require_relative '../lib/item_revenue_analyst'
require_relative '../lib/sales_engine'

class ItemRevenueAnalystTest < Minitest::Test
  attr_reader :item_revenue_analyst, :item_revenue_analyst2
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
    @item_revenue_analyst     = ItemRevenueAnalyst.new(@sales_engine)
    @item_revenue_analyst2    = ItemRevenueAnalyst.new(@sales_engine_mock)
  end

  def test_it_exists
    assert item_revenue_analyst
  end

  def test_it_takes_sales_engine_instance_as_argument
    assert ItemRevenueAnalyst.new(@sales_engine_mock)
  end

  def test_items_calls_sales_engine
    item_revenue_analyst2.sales_engine.expect(:all_items, nil, [])
    item_revenue_analyst2.items
    item_revenue_analyst2.sales_engine.verify
  end

  def test_most_sold_item_for_merchant_is_an_array
    assert_equal Array, item_revenue_analyst.most_sold_item_for_merchant(12335311).class
  end

  def test_item_quantities_of_merchant_is_a_hash
    assert_equal Hash, item_revenue_analyst.item_quantities_of_merchant(12334115).class
  end

  def test_most_sold_items_is_an_array
    assert_equal Array, item_revenue_analyst.most_sold_items.class
  end

  def test_item_quantities_is_a_hash
    assert_equal Hash, item_revenue_analyst.item_quantities.class
  end

  def test_all_invoice_items_is_an_array
    invoices = item_revenue_analyst.sales_engine.find_invoices(12334105)
    assert_equal Array, item_revenue_analyst.all_invoice_items(invoices).class
  end

  def test_complete_invoices
    invoices = item_revenue_analyst.sales_engine.find_invoices(12334105)
    assert item_revenue_analyst.complete_invoices(invoices).all? { |invoice| invoice.class == Invoice}
  end

  def test_best_item_for_merchant
    assert_equal [], item_revenue_analyst.best_item_for_merchant(12334115)
  end

  def test_items_and_revenue_is_a_hash
    assert_equal Hash, item_revenue_analyst.item_revenues_of_merchant(12334115).class
  end

  def test_best_items_returns_top_revenue_items_in_an_array
    assert_equal Array, item_revenue_analyst.best_items.class
  end

  def test_item_revenues_is_a_hash
    assert_equal Hash, item_revenue_analyst.item_revenues.class
  end

  def test_top_items_by_revenue
    result = item_revenue_analyst.top_items_by_revenue({111111 => 10, 22222 => 15})
    assert_equal Array, result.class
  end

end
