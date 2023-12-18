defmodule ExampleWeb.UserSessionControllerTest do
  use ExampleWeb.ConnCase, async: true

  import Example.UsersFixtures

  alias Example.Repo

  setup do
    %{user: user_fixture()}
  end

  defp create_login_token(user) do
    {email_token, token} = Example.Users.UserToken.build_email_token(user, "magic_link")

    Repo.insert!(token)

    email_token
  end

  describe "POST /login (sending magic link)" do
    test "sends a link", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/login", %{
          "user" => %{"email" => user.email}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "We've sent an email to #{user.email}, with a one-time sign-in link."

      assert Repo.get_by!(Example.Users.UserToken, user_id: user.id).context ==
               "magic_link"
    end
  end

  describe "POST /login/email/token/:token (logging in with magic link)" do
    test "logs the user in", %{conn: conn, user: user} do
      token = create_login_token(user)

      conn =
        get(conn, ~p"/login/email/token/#{token}")

      assert redirected_to(conn) == ~p"/"
      assert get_session(conn, :user_token)

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ user.email
      assert response =~ ~p"/account"
      assert response =~ ~p"/logout"
    end
  end

  describe "DELETE /logout" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> login_user(user) |> delete(~p"/logout")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/logout")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end
  end
end
