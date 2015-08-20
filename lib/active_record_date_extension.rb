module ActiveRecordDateExtension
  extend ActiveSupport::Concern

  included do
    def self.method_missing(method_sym, *arguments, &block)
      return super unless descends_from_active_record?
      match = ModelDateExtensionMatch.new(self,method_sym)

      if match.match?
        operators = { after: ">", before: "<" }
        singleton_class.class_eval do
          define_method("#{match.attribute}_#{match.suffix}") do |date|
            where("#{match.attribute} #{operators[match.suffix]} ?", date)
          end
        end
        send(method_sym, arguments.first)
      else
        super
      end
    end

    def self.respond_to?(method_sym, include_private = false)
      return super unless descends_from_active_record?
      if ModelDateExtensionMatch.new(self,method_sym).match?
        true
      else
        super
      end
    end
  end

  class ModelDateExtensionMatch

    attr_accessor :attribute,:suffix

    def initialize(model,method_sym)
      date_columns = model.columns_hash.keys.select { |c| [:datetime,:date].include? model.columns_hash[c].type }.map(&:to_sym)
      if method_sym.to_s =~ /^(.+)_(before|after)$/
        if date_columns.include? $1.to_sym
          @attribute = $1.to_sym
          @suffix = $2.to_sym
        end
      end

    end

    def match?
      @attribute != nil
    end
  end

end

ActiveRecord::Base.send(:include,ActiveRecordDateExtension)
