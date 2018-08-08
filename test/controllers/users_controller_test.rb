require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  # Test de l'inscription

  test "Création d'utilisateur avec un champ manquant" do
    post users_path, params: { user: { first_name: "", last_name: "test2", email: "test2@test.com", password: "test2", password_confirmation: "test2", remember_me: 0 } }
    get root_path
    assert_select("a[href=?]", "/login")
  end

  test "Création d'utilisateur avec un mail déjà existant" do
    post users_path, params: { user: { first_name: "test3", last_name: "test3", email: "test3@test.com", password: "test3", password_confirmation: "test3", remember_me: 0 } }
    delete logout_path
    post users_path, params: { user: { first_name: "test4", last_name: "test4", email: "test3@test.com", password: "test4", password_confirmation: "test4", remember_me: 0 } }
    get root_path
    assert_select("a[href=?]", "/login")
  end


  # Test de la page du club

  test "Accès interdit à la page de club si pas login" do
    get users_path
    assert_no_match("h3", 'Liste des membres du club')
  end

  test "Page de club accessible aux utilisateurs loggés, et complète" do
    post users_path, params: { user: { first_name: "test7", last_name: "test7", email: "test7@test.com", password: "test7", password_confirmation: "test7", remember_me: 0 } }
    delete logout_path
    post login_path, params: { session: { email: "test7@test.com", password: "test7", password_confirmation: "test7", remember_me: 0 } }
    get users_path
    assert_select("h3", 'Liste des membres du club')            # Teste si la page est accessible
    assert_select("h6") do                                      # Teste si la page est complète
      assert_select("h6", User.count)
    end
  end


  # Test de la page show

  test "Accès à la page show autorisé si loggé" do
    post users_path, params: { user: { first_name: "test8", last_name: "test8", email: "test8@test.com", password: "test8", password_confirmation: "test8", remember_me: 0 } }
    delete logout_path
    post login_path, params: { session: { email: "test8@test.com", password: "test8", password_confirmation: "test8", remember_me: 0 } }
    get user_path(User.find_by(email: "test8@test.com"))
    assert_select("a[href=?]", user_path(User.find_by(email: "test8@test.com")))    # Teste si lien page show activé dans la navbar
    assert_select("h3", "Page d'utilisateur")                                       # Teste si la page show fonctionne
  end

  test "Accès interdit à la page show si pas loggé" do
    post users_path, params: { user: { first_name: "test9", last_name: "test9", email: "test9@test.com", password: "test9", password_confirmation: "test9", remember_me: 0 } }
    delete logout_path
    assert_no_match("a[href=?]", user_path(User.find_by(email: "test9@test.com")))  # Teste si la page show est désativée pour un utilisateur non loggé
    get user_path(User.find_by(email: "test9@test.com"))
    assert_equal('hey login-toi pour y accéder', flash[:danger])                    # Teste si message d'erreur OK
    assert_redirected_to login_path                                                 # Teste si redirection OK
  end

  test "Accès autorisé à la page show d'autres utilisateurs en étant loggé" do
    post users_path, params: { user: { first_name: "test10", last_name: "test10", email: "test10@test.com", password: "test10", password_confirmation: "test10", remember_me: 0 } }
    delete logout_path
    post users_path, params: { user: { first_name: "test11", last_name: "test11", email: "test11@test.com", password: "test11", password_confirmation: "test11", remember_me: 0 } }
    delete logout_path
    post login_path, params: { session: { email: "test11@test.com", password: "test11", password_confirmation: "test11", remember_me: 0 } }
    get user_path(User.find_by(email: "test10@test.com"))
    assert_select("h3", "Page d'utilisateur")                                       # Teste si la page show fonctionne
  end


  # Test de la page edit
  
  test "Accès à la page edit autorisé si loggé" do
    post users_path, params: { user: { first_name: "test12", last_name: "test12", email: "test12@test.com", password: "test12", password_confirmation: "test12", remember_me: 0 } }
    delete logout_path
    post login_path, params: { session: { email: "test12@test.com", password: "test12", password_confirmation: "test12", remember_me: 0 } }
    get user_path(User.find_by(email: "test12@test.com"))
    assert_select("a[href=?]", edit_user_path(User.find_by(email: "test12@test.com")))      # Teste si lien page edit activé dans la navbar
    get edit_user_path(User.find_by(email: "test12@test.com"))
    assert_select("h3", "Modification de l'utilisateur")                                    # Teste si la page edit fonctionne
  end

  test "Accès interdit à la page edit si pas loggé" do
    post users_path, params: { user: { first_name: "test13", last_name: "test13", email: "test13@test.com", password: "test13", password_confirmation: "test13", remember_me: 0 } }
    delete logout_path
    get edit_user_path(User.find_by(email: "test13@test.com"))
    assert_equal('Touche pas à ça coquin', flash[:danger])                                  # Teste si message d'erreur OK
    assert_redirected_to login_path                                                         # Teste si redirection OK
  end

  test "Accès interdit à la page edit d'autres utilisateurs meme étant loggé" do
    post users_path, params: { user: { first_name: "test14", last_name: "test14", email: "test14@test.com", password: "test14", password_confirmation: "test14", remember_me: 0 } }
    delete logout_path
    post users_path, params: { user: { first_name: "test15", last_name: "test15", email: "test15@test.com", password: "test15", password_confirmation: "test15", remember_me: 0 } }
    delete logout_path
    post login_path, params: { session: { email: "test15@test.com", password: "test15", password_confirmation: "test15", remember_me: 0 } }
    get edit_user_path(User.find_by(email: "test14@test.com"))
    assert_equal('Touche pas à ça coquin', flash[:danger])                                  # Teste si message d'erreur OK
    assert_redirected_to root_path                                                          # Teste si redirection OK
  end
end
