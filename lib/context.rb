class Context
  def self.eval(file)
    c = Context.new
    c.instance_eval(file)
    c
  end
end