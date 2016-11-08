require_relative 'test_helper'
require_relative '../lib/one_item_merchant_analyst'
require_relative '../lib/sales_engine'

class OneItemMerchantAnalystTest < Minitest::Test
  attr_reader :one_item_merchant_analyst, :one_item_merchant_analyst2
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
    @one_item_merchant_analyst     = OneItemMerchantAnalyst.new(@sales_engine)
    @one_item_merchant_analyst2    = OneItemMerchantAnalyst.new(@sales_engine_mock)
  end

  def test_it_exists
    assert one_item_merchant_analyst
  end

  def test_it_takes_sales_engine_instance_as_argument
    assert OneItemMerchantAnalyst.new(@sales_engine_mock)
  end

  def test_items_calls_sales_engine
    one_item_merchant_analyst2.sales_engine.expect(:all_items, nil, [])
    one_item_merchant_analyst2.items
    one_item_merchant_analyst2.sales_engine.verify
  end

  def test_merchants_calls_sales_engine
    one_item_merchant_analyst2.sales_engine.expect(:all_merchants, nil, [])
    one_item_merchant_analyst2.merchants
    one_item_merchant_analyst2.sales_engine.verify
  end

  def test_merchants_with_only_one_item
    assert_equal Merchant, one_item_merchant_analyst.merchants_with_only_one_item[0].class
  end

  def test_merchants_with_only_one_item_registered_in_month
    assert_equal Merchant, one_item_merchant_analyst.merchants_with_only_one_item_registered_in_month("June").first.class
  end

  def test_merchants_by_reg_month_returns_hash_of_month_keys_and_merchant_values
    assert_equal Hash, one_item_merchant_analyst.merchants_by_registration_month.class
    assert_equal "December", one_item_merchant_analyst.merchants_by_registration_month.keys.first
    assert one_item_merchant_analyst.merchants_by_registration_month.values.all? { |array| array.all? { |item| item.class == Merchant } }
  end

end
