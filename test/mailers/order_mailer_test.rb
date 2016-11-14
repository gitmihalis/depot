require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received(orders(:one))
    assert_equal "Depot received your order", mail.subject
    assert_equal ["tim@homeimprovement.com"], mail.to
    assert_equal ["mihalis@example.com"], mail.from
    assert_match /Programming PHP 1.1/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "Your order from Depot has been shipped", mail.subject
    assert_equal ["tim@homeimprovement.com"], mail.to
    assert_equal ["mihalis@example.com"], mail.from
    assert_match /<td>1 &times;<\/td>\s*<td>Programming PHP 1.1<\/td>/, mail.body.encoded
  end

end
