require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest

  fixtures :products
  include ActiveJob::TestHelper

  test "buying a product" do
    start_order_count = Order.count
    php_book = products(:php)

    get "/"
    assert_response :success
    assert_select 'h1', 'Your Pragmatic Catalogue'

    post '/line_items', params: { product_id: php_book.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal php_book, cart.line_items[0].product

    get '/orders/new'
    assert_response :success
    assert_select 'legend', 'Please enter your details'

    perform_enqueued_jobs do
      post '/orders', params: {
        order: {
          name: "Tim Allen",
          address: "33 Maple Drive",
          email: "tim@homeimprovement.com",
          pay_type: "Check"
        }
      }
      follow_redirect!

      assert_response :success
      assert_select 'h1', 'Your Pragmatic Catalogue'
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size

      assert_equal start_order_count + 1, Order.count
      order = Order.last
      assert_equal "Tim Allen", order.name
      assert_equal "33 Maple Drive", order.address
      assert_equal  "tim@homeimprovement.com", order.email
      assert_equal "Check", order.pay_type

      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal php_book, line_item.product

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["tim@homeimprovement.com"], mail.to
      assert_equal "Mihalis F. <mihalis@example.com>", mail[:from].value
      assert_equal "Depot received your order", mail.subject
    end
  end
end
