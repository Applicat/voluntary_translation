# This migration comes from voluntary_translation_engine (originally 20131006062915)
class AddTranslationProduct < ActiveRecord::Migration
  def up
    product = Product::Translation.create(name: 'Translation', text: 'Dummy')
  end

  def down
    Product::Translation.first.destroy
  end
end
