require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  # Test du login

  test "Login d'utilisateur normal tout va bien" do
    post users_path, params: { user: { first_name: "test5", last_name: "test5", email: "test5@test.com", password: "test5", password_confirmation: "test5", remember_me: 0 } }
    delete logout_path
    post login_path, params: { session: { email: "test5@test.com", password: "test5", password_confirmation: "test5", remember_me: 0 } }
    get root_path
    assert_select("a[href=?]", logout_path)
  end

  test "Présence message d'erreur quand mauvais mail au login" do
    post users_path, params: { user: { first_name: "test6", last_name: "test6", email: "test6@test.com", password: "test6", password_confirmation: "test6", remember_me: 0 } }
    delete logout_path
    post login_path, params: { session: { email: "test_false6@test.com", password: "test6", password_confirmation: "test6", remember_me: 0 } }
    get root_path
    assert_equal('Ya un problème mon coco', flash[:danger])
  end

end
