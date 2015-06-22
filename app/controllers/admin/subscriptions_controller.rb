class Admin::SubscriptionsController < ApplicationController
  before_action :admin_access

  # POST /admin/users/:user_id/subscriptions
  def create
    @user = User.find(params[:user_id])
    @user.subscriptions.create
    SubscriptionsMailer.welcome_mail(@user).deliver_now
    SubscriptionsMailer.delay_for(24.hours.from_now).welcome_hangout(@user)
  end

  # PATCH /admin/users/:user_id/subscriptions/:id/cancel
  def cancel
    @user = User.find(params[:user_id])
    @subscription = Subscription.find(params[:id])
    @subscription.cancel
  end

  protected

  def subscription_cancellation_params
    params.require(:subscription).permit(:cancellation_reason)
  end

end
