require 'rails_helper'

RSpec.describe "Commentables" do
  before do
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

  it "should implement 'to_s' method" do
    commentables.each do |model|
      expect(model.method_defined? :to_s).to eq(true), "#{model.name} should implement #to_s"
    end
  end

  it "should implement 'to_path' method" do
    commentables.each do |model|
      expect(model.method_defined? :to_path).to eq(true), "#{model.name} should implement #to_path"
    end
  end
end
