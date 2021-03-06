require_relative 'test_helper'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :invoice_repo
   def setup
    parent        = Minitest::Mock.new
    @invoice_repo = InvoiceRepository.new('./data/test_invoices.csv', parent)
  end

  def test_it_exists
    assert InvoiceRepository.new
  end

  def test_it_initializes_with_a_file
    assert InvoiceRepository.new('./data/test_invoices.csv')
  end

  def test_it_has_custom_inspect
    assert_equal "#<InvoiceRepository: 56 rows>", invoice_repo.inspect
  end

  def test_find_merchant_by_id_calls_parent
    invoice_repo.parent.expect(:find_merchant_by_id, nil, [10])
    invoice_repo.find_merchant_by_id(10)
    invoice_repo.parent.verify
  end

  def test_find_transactions_by_invoice_id_calls_parent
    invoice_repo.parent.expect(:find_transactions_by_invoice_id, nil, [5])
    invoice_repo.find_transactions_by_invoice_id(5)
    invoice_repo.parent.verify
  end

  def test_find_customer_by_id_calls_parent
    invoice_repo.parent.expect(:find_customer_by_id, nil, [5])
    invoice_repo.find_customer_by_id(5)
    invoice_repo.parent.verify
  end

  def test_find_items_by_invoice_id_calls_parent
    invoice_repo.parent.expect(:find_items_by_invoice_id, nil, [5])
    invoice_repo.find_items_by_invoice_id(5)
    invoice_repo.parent.verify
  end

  def test_find_invoice_items_for_invoice_id_calls_parent
    invoice_repo.parent.expect(:find_invoice_items_for_invoice, nil, [5])
    invoice_repo.find_invoice_items_for_invoice(5)
    invoice_repo.parent.verify
  end

  def test_it_turns_file_contents_to_CSV_object
    assert_equal CSV, invoice_repo.file_contents.class
  end

  def test_it_generates_array_of_item_objects_from_csv_object
    assert invoice_repo.all.all?{|row| row.class == Invoice}
  end

  def test_it_calls_id_of_invoice_object
    assert_equal 1, invoice_repo.all[0].id
  end

  def test_it_retrieves_all_invoice_objects
    assert_equal Invoice, invoice_repo.all[0].class
    assert_equal 56, invoice_repo.all.count
  end

  def test_invoice_ids_are_uniq
    ids = invoice_repo.all {|row| row[:id]}
    assert_equal ids, ids.uniq
  end

  def test_find_invoice_by_id_returns_an_instance_of_invoice
    invoice = invoice_repo.find_by_id(1)
    assert_equal Invoice, invoice.class
    assert_equal 1, invoice.id
  end

  def test_find_invoice_by_id_for_different_id
    invoice = invoice_repo.find_by_id(20)
    assert_equal Invoice, invoice.class
    assert_equal 20, invoice.id
  end

  def test_it_returns_nil_if_id_not_found
    invoices = invoice_repo.find_by_id(123)
    assert_equal nil,invoices
  end

  def test_it_finds_all_invoices_by_customer_id
    invoices    = invoice_repo.find_all_by_customer_id(4)
    assert_equal 3, invoices.count
    assert invoices.all? {|invoice| invoice.customer_id == 4}
    assert invoices.all? {|invoice| invoice.class == Invoice}
  end

  def test_it_finds_all_invoices_by_different_customer_id
    invoices = invoice_repo.find_all_by_customer_id(13)
    assert_equal 2, invoices.count
    assert invoices.all? {|invoice| invoice.customer_id == 13}
    assert invoices.all? {|invoice| invoice.class == Invoice}
  end

  def test_it_returns_nil_if_customer_id_is_not_found
    invoices = invoice_repo.find_all_by_customer_id(1000000)
    assert_equal [], invoices.map{|item| item.merchant_id}
  end

  def test_it_finds_all_by_merchant_id
    invoices = invoice_repo.find_all_by_merchant_id(2)
    assert_equal 2, invoices.count
    assert invoices.all? {|invoice| invoice.merchant_id == 2}
    assert invoices.all? {|invoice| invoice.class == Invoice}
  end

  def test_it_finds_all_by_different_merchant_id
    invoices = invoice_repo.find_all_by_merchant_id(4)
    assert_equal 1, invoices.count
    assert invoices.all? {|invoice| invoice.merchant_id == 4}
    assert invoices.all? {|invoice| invoice.class == Invoice}
  end

  def test_it_returns_nil_if_merchant_id_is_not_found
    invoices = invoice_repo.find_all_by_merchant_id(10000000)
    assert_equal [], invoices.map{|item| item.merchant_id}
  end

  def test_it_finds_all_of_a_status
    invoices = invoice_repo.find_all_by_status(:pending)
    assert_equal 23, invoices.count
    assert invoices.all? {|invoice| invoice.status == :pending}
  end

  def test_it_finds_all_of_a_different_status
    invoices = invoice_repo.find_all_by_status(:shipped)
    assert_equal 29, invoices.count
    assert invoices.all? {|invoice| invoice.status == :shipped}    
  end

end
