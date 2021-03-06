require_relative 'test_helper'
require_relative '../lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test

  def setup
    @sales_engine = Minitest::Mock.new
    @merch_repo = MerchantRepository.new('./data/test_merchants.csv', @sales_engine)
  end

  def test_it_exists
    assert MerchantRepository.new
  end

  def test_it_has_custom_inspect
    assert_equal "#<MerchantRepository: 31 rows>", @merch_repo.inspect
  end

  def test_it_initializes_with_a_file
    assert MerchantRepository.new('./data/test_merchants.csv')
  end

  def test_it_initializes_with_reference_to_sales_engine_parent
    assert @merch_repo.parent
  end

  def test_find_items_by_id_calls_parent
    @merch_repo.parent.expect(:find_items_by_merchant_id, nil, [5])
    @merch_repo.find_items_by_merchant_id(5)
    @merch_repo.parent.verify
  end

  def test_find_invoices_calls_parent
    @merch_repo.parent.expect(:find_invoices, nil, [5])
    @merch_repo.find_invoices(5)
    @merch_repo.parent.verify
  end

  def test_find_customers_of_merchant_calls_parent
    @merch_repo.parent.expect(:find_customers_of_merchant, nil, [5])
    @merch_repo.find_customers_of_merchant(5)
    @merch_repo.parent.verify
  end

  def test_find_invoices_calls_parent
    @merch_repo.parent.expect(:find_invoices, nil, [5])
    @merch_repo.find_invoices(5)
    @merch_repo.parent.verify
  end

  def test_it_turns_file_contents_to_CSV_object
    assert_equal CSV, @merch_repo.file_contents.class
  end

  def test_it_generates_array_of_merchant_objects_from_csv_object
    assert @merch_repo.all.all? {|merchant| merchant.class == Merchant}
  end

  def test_it_calls_id_of_merchant_object
    assert_equal 1, @merch_repo.all[0].id
  end

  def test_it_calls_name_of_merchant_object
    assert_equal "Shopin1901", @merch_repo.all[0].name
  end

  def test_it_calls_name_of_different_merchant_object
    assert_equal "Urcase17", @merch_repo.all[8].name
  end

  def test_it_retrieves_all_merchant_objects
    assert_equal 31, @merch_repo.all.count
  end

  def test_merchant_ids_are_uniq
    ids = @merch_repo.all {|row| row[:id]}
    assert_equal ids, ids.uniq
  end

  def test_it_finds_merchant_by_id
    merchant = @merch_repo.find_by_id(1)
    assert_equal Merchant, merchant.class
    assert_equal 1, merchant.id
  end

  def test_it_finds_merchant_by_id_for_different_merchant
    merchant = @merch_repo.find_by_id(17)
    assert_equal Merchant, merchant.class
    assert_equal 17, merchant.id
  end

  def test_it_returns_nil_if_id_not_found
    id = "123"
    merchant = @merch_repo.find_by_id(id)
    assert_equal nil, merchant
  end

  def test_it_finds_merchant_by_name
    name = "Shopin1901"
    merchant = @merch_repo.find_by_name(name)
    assert_equal Merchant, merchant.class
    assert_equal name, merchant.name
  end

  def test_it_finds_merchant_by_name_case_insensitive
    name = "KeckenBAuer"
    merchant = @merch_repo.find_by_name(name.upcase)
    assert_equal Merchant, merchant.class
    assert_equal name.capitalize, merchant.name
  end

  def test_it_returns_nil_if_name_not_found
    name = "mike"
    merchant = @merch_repo.find_by_name(name)
    assert_equal nil, merchant
  end

  def test_it_finds_all_merchants_by_name
    name      = "shop"
    shops     = ["Shopin1901", "GoldenRaySHop"]
    merchants = @merch_repo.find_all_by_name(name)
    assert_equal shops, merchants.map{|merchant| merchant.name}
  end

  def test_it_finds_all_merchants_by_name_fragment_case_insensitive
    name      = "OWLS"
    shops     = ["BowlsByChris", "LowlsLyChris"]
    merchants = @merch_repo.find_all_by_name(name)
    assert_equal shops, merchants.map{|merchant| merchant.name}
  end

  def test_it_returns_empty_array_if_name_not_found
    name      = "schutte"
    merchants = @merch_repo.find_all_by_name(name)
    assert_equal [], merchants.map{|merchant| merchant.name}
  end

end
