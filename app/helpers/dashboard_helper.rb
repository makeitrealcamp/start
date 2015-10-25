module DashboardHelper
  def next_step
    return 'finished' if @challenge.nil?
    @is_new_challenge ? 'start_challenge' : 'continue_challenge'
  end
end
