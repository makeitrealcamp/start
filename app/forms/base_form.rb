class BaseForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  protected
    def persist!
      raise "persist! not defined. You should define persist! method for each form"
    end
end
