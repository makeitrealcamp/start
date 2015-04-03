ENV['KISSMETRICS_KEY'] ||= "e15ab900b04460672c7f6e7ce1407339c8305f9d"
KMTS.init(ENV['KISSMETRICS_KEY'], log_dir: File.join(Rails.root, 'log'))