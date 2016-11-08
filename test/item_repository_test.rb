require_relative 'test_helper'
require_relative '../lib/item_repository'

class ItemRepositoryTest < Minitest::Test
  
   def setup
    parent = Minitest::Mock.new
    @item_repo = ItemRepository.new('./data/test_items.csv', parent)
  end

  def test_it_exists
    assert ItemRepository.new
  end

  def test_it_initializes_with_a_file
    assert ItemRepository.new('./data/test_items.csv')
  end

  def test_it_has_custom_inspect
    assert_equal "#<ItemRepository: 67 rows>", @item_repo.inspect
  end

  def test_find_all_by_merchant_id_calls_parent
    @item_repo.parent.expect(:find_merchant_by_id, nil, [5])
    @item_repo.find_merchant_by_id(5)
    @item_repo.parent.verify
  end

  def test_it_turns_file_contents_to_CSV_object
    assert_equal CSV, @item_repo.file_contents.class
  end

  def test_it_generates_array_of_item_objects_from_csv_object
    assert @item_repo.all.all?{|row| row.class == Item}
  end

  def test_it_calls_id_of_item_object
    assert_equal 1, @item_repo.all[0].id
  end

  def test_it_calls_name_of_item_object
    assert_equal "The George Daddy", @item_repo.all[0].name
  end

  def test_it_calls_name_of_different_item_object
    assert_equal "The Original Frozen Banana", @item_repo.all[4].name
  end

  def test_it_retrieves_all_item_objects
    assert_equal 67, @item_repo.all.count
  end

  def test_item_ids_are_uniq
    ids = @item_repo.all {|row| row[:id]}
    assert_equal ids, ids.uniq
  end

  def test_it_finds_item_by_id
    item = @item_repo.find_by_id(2)
    assert_equal Item, item.class
    assert_equal 2, item.id
  end

  def test_it_finds_item_by_different_id
    item = @item_repo.find_by_id(19)
    assert_equal Item, item.class
    assert_equal 19, item.id
  end

  def test_it_returns_nil_if_id_not_found
    id = 123
    item = @item_repo.find_by_id(id)
    assert_equal nil, item
  end

  def test_it_finds_item_by_name
    name = "510+ RealPush Icon Set"
    item = @item_repo.find_by_name(name)
    assert_equal Item, item.class
    assert_equal name, item.name
  end

  def test_it_finds_item_by_different_name_case_insensitive
    name = "The Simple SIMON"
    item = @item_repo.find_by_name(name)
    assert_equal Item, item.class
    assert_equal name.downcase, item.name
  end

  def test_it_returns_nil_if_name_not_found
    name = "mike"
    item = @item_repo.find_by_name(name)
    assert_equal nil, item
  end

  def test_it_finds_items_by_description
    description = "frames"
    items = @item_repo.find_all_with_description(description)
    assert items.all? {|item| item.class == Item}
    assert items.all? {|item| item.description.include?("frames")}
    assert_equal 2, items.map{|item| item.description}.count
  end

  def test_it_finds_items_by_different_description_case_insensitive
    description = "baNaNa"
    items = @item_repo.find_all_with_description(description)
    assert items.all? {|item| item.class == Item}
    assert items.all? {|item| item.description.include?("banana")}
    assert_equal 30, items.map{|item| item.description}.count
  end

  def test_it_returns_nil_if_description_not_found
    description = "schutte"
    items = @item_repo.find_all_with_description(description)
    assert_equal [], items.map{|item| item.description}
  end

  def test_it_finds_items_by_price
    price = 12.00
    items = @item_repo.find_all_by_price(price)
    assert items.all? {|item| item.class == Item}
    assert items.all?{|item| item.unit_price == 12.00}
  end

  def test_it_finds_items_by_different_price
    price = 15.02
    items = @item_repo.find_all_by_price(price)
    assert items.all? {|item| item.class == Item}
    assert items.all?{|item| item.unit_price == 15.02}
  end

  def test_it_returns_nil_if_price_not_found
    price = 10000000
    items = @item_repo.find_all_by_price(price)
    assert_equal [], items.map{|item| item.unit_price}
  end

  def test_it_finds_items_by_price_range
    price_range = (0..10)
    items = @item_repo.find_all_by_price_in_range(price_range)
    assert items.all? {|item| item.class == Item}
    assert items.all? {|item| item.unit_price.between?(0, 10) }
    assert_equal 3, items.count
  end

  def test_it_finds_items_by_different_price_range
    price_range = (100..500)
    items = @item_repo.find_all_by_price_in_range(price_range)
    assert items.all? {|item| item.class == Item}
    assert items.all? {|item| item.unit_price.between?(100, 500) }
    assert_equal 12, items.count
  end

  def test_it_returns_nil_if_no_items_in_price_range
    price_range = (100000..10000000)
    items = @item_repo.find_all_by_price_in_range(price_range)
    assert_equal [], items.map{|item| item.merchant_id}
  end

  def test_it_finds_items_by_merchant_id
    items = @item_repo.find_all_by_merchant_id(5)
    assert items.all? {|item| item.class == Item}
    assert items.all?{|item| item.merchant_id == 5}
  end

  def test_it_finds_items_by_different_merchant_id
    items = @item_repo.find_all_by_merchant_id(16)
    assert items.all? {|item| item.class == Item}
    assert items.all?{|item| item.merchant_id == 16}
  end

  def test_it_returns_nil_if_merchant_id_is_not_found
    merchant_id = 10000000
    items = @item_repo.find_all_by_merchant_id(merchant_id)
    assert_equal [], items.map{|item| item.merchant_id}
  end

end
