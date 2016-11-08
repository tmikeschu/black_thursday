require_relative 'test_helper'
require_relative '../lib/invoice_count_analyst'
require_relative '../lib/sales_engine'

class InvoiceCountAnalystTest < Minitest::Test
  attr_reader :invoice_count_analyst, :invoice_count_analyst2
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
    @invoice_count_analyst     = InvoiceCountAnalyst.new(@sales_engine)
    @invoice_count_analyst2    = InvoiceCountAnalyst.new(@sales_engine_mock)
  end

  def test_it_exists
    assert invoice_count_analyst
  end

  def test_it_takes_sales_engine_instance_as_argument
    assert InvoiceCountAnalyst.new(@sales_engine_mock)
  end

  def test_items_calls_sales_engine
    invoice_count_analyst2.sales_engine.expect(:all_items, nil, [])
    invoice_count_analyst2.items
    invoice_count_analyst2.sales_engine.verify
  end

  def test_merchants_calls_sales_engine
    invoice_count_analyst2.sales_engine.expect(:all_merchants, nil, [])
    invoice_count_analyst2.merchants
    invoice_count_analyst2.sales_engine.verify
  end

  def test_invoices_calls_sales_engine
    invoice_count_analyst2.sales_engine.expect(:all_invoices, nil, [])
    invoice_count_analyst2.invoices
    invoice_count_analyst2.sales_engine.verify
  end

  def test_average_invoices_per_merchant_returns_a_float_average
    assert_equal Float, invoice_count_analyst.average_invoices_per_merchant.class
    assert_equal  1.65, invoice_count_analyst.average_invoices_per_merchant
  end
  
  def test_invoices_per_merchant_standard_deviation
    assert_equal Float, invoice_count_analyst.average_invoices_per_merchant_standard_deviation.class
    assert_equal 1.2, invoice_count_analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_top_merchants_by_invoice_count_returns_array_of_top_merchants
    assert_equal Array, invoice_count_analyst.top_merchants_by_invoice_count.class
  end
  
  def test_bottom_merchants_by_invoice_count_returns_array_of_bottom_merchants
    assert_equal Array, invoice_count_analyst.bottom_merchants_by_invoice_count.class
  end

  def test_invoice_days_returns_array_of_day_numbers
    assert_equal Array, invoice_count_analyst.invoice_days.class
    assert_equal invoice_count_analyst.invoices.count, invoice_count_analyst.invoice_days.count
  end

  def test_invoice_days_returns_day_name
    assert invoice_count_analyst.invoice_days.all?{|day| day.include?("day")}
  end

  def test_average_invoices_per_day
    assert_equal 8.0, invoice_count_analyst.average_invoices_per_day
  end

  def test_average_invoices_per_day_std_dev
    assert_equal 3.83, invoice_count_analyst.average_invoices_per_day_standard_deviation
  end

  def test_top_days_by_invoice_count_returns_top_day_or_days
    assert_equal ["Saturday"], invoice_count_analyst.top_days_by_invoice_count
  end
  
  def test_invoice_status_returns_a_float
    status = :pending
    assert_equal Float, invoice_count_analyst.invoice_status(status).class
  end

  def test_invoice_status_returns_the_percentage_of_the_status
    status = :pending
    assert_equal 41.07, invoice_count_analyst.invoice_status(status)
  end

  

end
