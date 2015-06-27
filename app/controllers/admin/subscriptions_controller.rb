class Admin::SubscriptionsController < ApplicationController
  before_action :admin_access

  # POST /admin/users/:user_id/subscriptions
  def create
    @user = User.find(params[:user_id])
    @user.subscriptions.create
    if Rails.env.development?
      SubscriptionsMailer.welcome_mail(@user).deliver_now
      SubscriptionsMailer.welcome_hangout(@user).deliver_now
    else
      SubscriptionsMailer.welcome_mail(@user).deliver_now
      SubscriptionsMailer.welcome_hangout(@user).deliver_later!(wait: 24.hours)
    end
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
