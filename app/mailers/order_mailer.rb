class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  default from: 'Mihalis F. <mihalis@example.com>'

  def received(order)
    @order = order

    mail to: order.email, subject: 'Depot received your order'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order

    mail to: order.email, subject: 'Your order from Depot has been shipped'
  end
end