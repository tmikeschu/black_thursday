require_relative 'test_helper'
require_relative '../lib/merchant_revenue_analyst'
require_relative '../lib/sales_engine'

class MerchantRevenueAnalystTest < Minitest::Test
  attr_reader :merchant_revenue_analyst, :merchant_revenue_analyst2
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
    @merchant_revenue_analyst     = MerchantRevenueAnalyst.new(@sales_engine)
    @merchant_revenue_analyst2    = MerchantRevenueAnalyst.new(@sales_engine_mock)
  end

  def test_it_exists
    assert merchant_revenue_analyst
  end

  def test_it_takes_sales_engine_instance_as_argument
    assert MerchantRevenueAnalyst.new(@sales_engine_mock)
  end

  def test_merchants_calls_sales_engine
    merchant_revenue_analyst2.sales_engine.expect(:all_merchants, nil, [])
    merchant_revenue_analyst2.merchants
    merchant_revenue_analyst2.sales_engine.verify
  end

  def test_invoices_calls_sales_engine
    merchant_revenue_analyst2.sales_engine.expect(:all_invoices, nil, [])
    merchant_revenue_analyst2.invoices
    merchant_revenue_analyst2.sales_engine.verify
  end

  def test_total_revenue_by_date_returns_total_rev_by_date
    date = Time.parse("2012-02-26")
    assert_equal 0, merchant_revenue_analyst.total_revenue_by_date(date)
  end

  def test_invoices_on_date_finds_invoices_from_that_date
    date = Time.parse("2012-02-26")    
    assert_equal [], merchant_revenue_analyst.invoices_on_date(date)
  end

  def test_top_revenue_earners
    assert_equal Merchant, merchant_revenue_analyst.top_revenue_earners(5).first.class
  end

  def test_merchants_ranked_by_revenue
    assert_equal Merchant, merchant_revenue_analyst.merchants_ranked_by_revenue.first.class
  end

  def test_invoices_total_returns_a_fixnum_sum
    invoices = merchant_revenue_analyst.sales_engine.find_invoices(5)
    assert_equal Fixnum, merchant_revenue_analyst.invoices_total(invoices).class
  end

  def test_merchants_and_invoices_stores_merch_id_keys_and_invoice_values
    assert_equal Hash, merchant_revenue_analyst.merchants_and_invoices.class
    assert_equal Fixnum, merchant_revenue_analyst.merchants_and_invoices.keys[2].class
    assert_equal Invoice, merchant_revenue_analyst.merchants_and_invoices.values[0][0].class
  end

  def test_revenue_by_merchant_returns_revenue_total
    assert_equal BigDecimal.new('0.7348E2'), merchant_revenue_analyst.revenue_by_merchant(3)
  end

end
