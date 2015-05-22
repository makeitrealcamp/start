module FriendlyId
  module AlwaysUpdate
    def should_generate_new_friendly_id?
      slug.blank? || self.send("#{self.friendly_id_config.base.to_s}_changed?")
    end
  end
end
