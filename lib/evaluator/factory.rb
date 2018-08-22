class Evaluator::Factory
  def self.create(solution)
    challenge = solution.challenge
    if challenge.ruby_embedded?
      Evaluator::Ruby.new(solution)
    elsif challenge.phantomjs_embedded?
      Evaluator::Phantom.new(solution)
    elsif challenge.ruby_git?
      Evaluator::Git.new(solution)
    elsif challenge.rails_git?
      Evaluator::RailsGit.new(solution)
    elsif challenge.sinatra_git?
      Evaluator::Sinatra.new(solution)
    elsif challenge.ruby_git_pr?
      Evaluator::GitPR.new(solution)
    elsif challenge.async_phantomjs_embedded?
      Evaluator::AsyncPhantom.new(solution)
    elsif challenge.react_git?
      Evaluator::ReactGit.new(solution)
    elsif challenge.nodejs_embedded?
      Evaluator::Nodejs.new(solution)
    elsif challenge.puppeteer_embedded?
      Evaluator::Puppeteer.new(solution)
    elsif challenge.express_git?
      Evaluator::Express.new(solution)
    end
  end
end
