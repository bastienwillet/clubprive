require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest

  # Test de la page d'accueil et de la navbar

  test "Test présence liens login et nouvel utilisateur si l'utilisateur est déconnecté (+ pas de liens logout ou page club)" do
    get root_path
    assert_select("a[href=?]", login_path) do
      assert_select("a[href=?]", login_path, 2)
    end
    assert_select("a[href=?]", new_user_path)
    assert_no_match("a[href=?]", users_path)
    assert_no_match("a[href=?]", logout_path)
  end

  test "Test présence liens page club et logout si l'utilisateur est connecté (+ pas de liens login et nouvel utilisateur)" do
    post users_path, params: { user: { first_name: "test1", last_name: "test1", email: "test1@test.com", password: "test1", password_confirmation: "test1", remember_me: 0 } }
    delete logout_path
    post login_path, params: { session: { email: "test1@test.com", password: "test1", password_confirmation: "test1", remember_me: 0 } }
    get root_path
    assert_select("a[href=?]", users_path)
    assert_select("a[href=?]", logout_path)
    assert_no_match("a[href=?]", login_path)
    assert_no_match("a[href=?]", new_user_path)
  end

end