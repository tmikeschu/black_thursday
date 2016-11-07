require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'

sales_engine = SalesEngine.from_csv({
  :items          => "./data/items.csv",
  :merchants      => "./data/merchants.csv",
  :invoices       => "./data/invoices.csv",
  :invoice_items  => "./data/invoice_items.csv",
  :customers      => "./data/customers.csv",
  :transactions   => "./data/transactions.csv"
})

@sales_analyst = SalesAnalyst.new(sales_engine)