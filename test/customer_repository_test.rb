require_relative 'test_helper'
require_relative '../lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customer_repo
   def setup
    parent        = Minitest::Mock.new
    @customer_repo = CustomerRepository.new('./data/test_customers.csv', parent)
  end

  def test_it_exists
    assert CustomerRepository.new
  end

  def test_it_initializes_with_a_file
    assert CustomerRepository.new('./data/test_customers.csv')
  end

  def test_it_has_custom_inspect
    assert_equal "#<CustomerRepository: 21 rows>", customer_repo.inspect
  end

  def test_find_all_by_merchant_id_calls_parent
    customer_repo.parent.expect(:find_merchants_of_customer, nil, [5])
    customer_repo.find_merchants_of_customer(5)
    customer_repo.parent.verify
  end

  def test_it_turns_file_contents_to_CSV_object
    assert_equal CSV, customer_repo.file_contents.class
  end

  def test_it_generates_array_of_customer_objects_from_csv_object
    assert customer_repo.all.all?{|row| row.class == Customer}
  end

  def test_it_calls_id_of_customer_object
    assert_equal 1, customer_repo.all[0].id
    assert_equal 6, customer_repo.all[5].id
  end

  def test_customer_ids_are_uniq
    ids = customer_repo.all {|row| row[:id]}
    assert_equal ids, ids.uniq
  end

  def test_find_invoice_by_id_returns_an_instance_of_invoice
    customer = customer_repo.find_by_id(1)
    assert_equal Customer, customer.class
    assert_equal 1, customer.id
    customer = customer_repo.find_by_id(11)
    assert_equal Customer, customer.class
    assert_equal 11, customer.id
  end

  def test_it_returns_nil_if_id_not_found
    customers = customer_repo.find_by_id(123)
    assert_equal nil,customers
  end

  def test_it_finds_all_customers_by_first_name
    customers  = customer_repo.find_all_by_first_name("Ramona")
    assert_equal 2, customers.count
    assert customers.all?{|customer| customer.class == Customer}
    assert_equal ["Ramona", "Ramona"], customers.map{|customer| customer.first_name}
  end

  def test_it_finds_all_customers_by_different_first_name
    customers  = customer_repo.find_all_by_first_name("Michael")
    assert_equal 2, customers.count
    assert customers.all?{|customer| customer.class == Customer}
    assert_equal ["Michael", "GeorgeMichael"], customers.map{|customer| customer.first_name}
  end

  def test_it_finds_all_customers_by_a_fragment_first_name
    customers  = customer_repo.find_all_by_first_name("ar")
    assert_equal 3, customers.count
    assert_equal ["Mariah", "Parker", "Oscar"], customers.map {|customer| customer.first_name}
  end

  def test_it_finds_all_customers_by_a_different_fragment_first_name
    customers  = customer_repo.find_all_by_first_name("be")
    assert_equal 1, customers.count
    assert_equal ["Heber"], customers.map {|customer| customer.first_name}
  end

  def test_it_returns_empty_array_if_no_first_names_are_found
    customers  = customer_repo.find_all_by_first_name("Jason")
    assert_equal [], customers
  end

  def test_it_finds_all_customers_by_a_fragment_last_name
    customers  = customer_repo.find_all_by_last_name("ad")
    assert_equal 2, customers.count
    assert customers.all?{|customer| customer.class == Customer}    
    assert_equal ["Nader", "Fadel"], customers.map {|customer| customer.last_name}
  end

  def test_it_finds_all_customers_by_a_fragment_last_name
    customers  = customer_repo.find_all_by_last_name("lu")
    assert_equal 8, customers.count
    assert customers.all?{|customer| customer.class == Customer}    
    assert_equal ["Bluth"]*8, customers.map {|customer| customer.last_name}
  end

  def test_it_returns_empty_array_if_no_last_names_are_found
    customers  = customer_repo.find_all_by_last_name("Schutte")
    assert_equal [], customers
  end

end
