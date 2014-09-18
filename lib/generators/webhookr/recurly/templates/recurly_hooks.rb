class RecurlyHooks

  # All 'on_' handlers are optional. Omit any you do not require.

  def on_canceled_subscription_notification(incoming)
    payload = incoming.payload
    # puts payload.account.account_code
    # puts payload.account.email
    # puts payload.subscription.state
    # puts payload.subscription.canceled_at
    # puts payload.subscription.expires_at
    # puts payload.subscription.plan.plan_code
    # puts payload.subscription.plan.name
  end

end
