web: ./run_web
worker: bundle exec sidekiq -c $SIDEKIQ_CONCURRENCY -q default -q mailers
