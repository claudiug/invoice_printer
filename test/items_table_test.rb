require 'test_helper'

class ItemsTableTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_omitting_name_column
    test_ommiting_column(column: 'name', label: :item)
  end

  def test_omitting_quantity_column
    test_ommiting_column(column: 'quantity', label: :quantity)
  end

  def test_omitting_unit_column
    test_ommiting_column(column: 'unit', label: :unit)
  end

  def test_omitting_price_column
    test_ommiting_column(column: 'price', label: :price_per_item)
  end

  # TODO: We need to distinguish between items' taxes and document taxes
  #
  #def test_omitting_tax_column
  #  test_ommiting_column(column: 'tax', label: :tax)
  #end

  def test_omitting_amount_column
    test_ommiting_column(column: 'amount', label: :amount)
  end

  private

  def test_ommiting_column(column:, label:)
    item = InvoicePrinter::Document::Item.new(
      default_document_item_params.merge("#{column}": nil)
    )
    invoice = InvoicePrinter::Document.new(
      default_document_params.merge(items: [item])
    )
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf = PDF::Inspector::Text.analyze(rendered_pdf)
    assert_equal false, pdf.strings.include?(InvoicePrinter.labels[label])
    strings = InvoicePrinter::PDFDocument.new(document: invoice).to_a
    assert_equal strings, pdf.strings
  end
end