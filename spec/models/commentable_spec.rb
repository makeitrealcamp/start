require 'rails_helper'

RSpec.describe "Commentables" do
  before do
    Rails.application.eager_load!
    class ActiveRecord::Base
      def self.has_many?(association)
        self.reflect_on_association(association) && self.reflect_on_association(association).macro == :has_many
      end
    end
  end

  let!(:commentables) do |variable|
    commentables = ActiveRecord::Base.descendants.select do |model|
      model != User && model.has_many?(:comments)
    end
    commentables << Comment
  end

  it "should implement 'name' method" do
    commentables.each do |model|
      expect(model.method_defined? :name_for_notification).to eq(true), "#{model.name} should implement #name_for_notification"
    end
  end

  it "should implement 'url' method" do
    commentables.each do |model|
      expect(model.method_defined? :url_for_notification).to eq(true), "#{model.name} should implement #url_for_notification"
    end
  end
end