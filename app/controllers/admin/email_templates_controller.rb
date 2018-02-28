class Admin::EmailTemplatesController < ApplicationController
	def index
		@template= EmailTemplate.new
	end

	def new
	end
	
	def show
	end
end
