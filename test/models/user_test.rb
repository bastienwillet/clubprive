require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # Test modèle User
  
  test "Prénom vide" do
    user = User.create(first_name: "", last_name: "b", email: "b@mail.com", password: "test")
    assert user.invalid?
  end

  test "Prénom qui ne comprend que des espaces" do
    user = User.create(first_name: "    ", last_name: "c", email: "c@mail.com", password: "test")
    assert user.invalid?
  end

  test "Même email qu'un autre user" do
    user_d = User.create(first_name: "d", last_name: "d", email: "d@mail.com", password: "test")
    user_e = User.create(first_name: "e", last_name: "e", email: "d@mail.com", password: "test")
    assert user_e.invalid?
  end
end
