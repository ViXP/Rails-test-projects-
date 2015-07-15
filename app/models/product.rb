class Product < ActiveRecord::Base
	validates :title, :description, :image_url, presence: true
	validates :price, numericality: {:greater_then_or_equal_to => 0.01}
	validates :title, uniqueness: true
	validates :image_url, allow_blank: true, format: ({
		:with => %r{\.(gif|jpg|jpeg|png)\Z}i, 
		:message => 'URL must point to the image'})

	def self.latest
		Product.order(:updated_at).last
	end
	
end
