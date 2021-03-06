require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products

	def new_product image_url
		Product.new(title: "My Book Title", 
					description: 'yyy', 
					price: 1, 
					image_url: image_url)
	end

	test "product attributes must not be empty" do
		product = Product.new
		product.invalid?
		product.errors[:title].any?
		product.errors[:description].any?
		product.errors[:price].any?
		product.errors[:image_url].any?
	end

	test "product price must be positive" do
		product = Product.new(title: products(:ruby).title,
							description: products(:ruby).description,
							image_url: products(:ruby).image_url)
	
		product.price = -1
		assert product.invalid?,  "#{product.price} shouldn't be invalid"
	end

	test "product is not valid without a unique title" do
		product = Product.new(title: products(:ruby).title,
							  description: 'yyy',
							  price: 1,
							  image_url: 'fred.gif')
		assert product.invalid?
		assert_equal ['has already been taken'], product.errors[:title]
	end

	test 'image_url' do
		ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c./x/y/z/fred.gif}
		bad =%w{fred.doc fred.gif/more fred.gif.more}
		ok.each do |name|
			assert new_product(name).valid?, "#{name} shouldn't be invalid"
		end
		bad.each do |name|
			assert new_product(name).invalid?, "#{name} shouldn't be valid"
		end
	end

	test 'product name length' do
		product = Product.new(title: products(:ruby).title,
							description: products(:ruby).description,
							image_url: products(:ruby).image_url)
		product.title.length < 10
		assert product.invalid?
	end
end
