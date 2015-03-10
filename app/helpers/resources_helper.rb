module ResourcesHelper

  def types_resources
    Resource.types.keys.to_a
  end
end
