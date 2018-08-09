defmodule HolidayApp.AuthTest do
  use HolidayApp.DataCase

  alias HolidayApp.Auth
  alias HolidayApp.Users.User

  def auth_struct(:identity, email, password) do
    %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{
        other: %{password: password}
      },
      info: %Ueberauth.Auth.Info{email: email},
      provider: :identity,
      strategy: Ueberauth.Strategy.Identity
    }
  end

  def auth_struct(:google, email, uid) do
    %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{},
      extra: %Ueberauth.Auth.Extra{
        raw_info: %{
          user: %{"hd" => "domain.com"}
        }
      },
      info: %Ueberauth.Auth.Info{
        email: email,
        image: "https://xyz.google.com/1234/image.jpg",
        name: "Dick Mountain",
        first_name: "Dick",
        last_name: "Mountain"
      },
      provider: :google,
      strategy: Ueberauth.Strategy.Google,
      uid: uid
    }
  end

  describe "authenticate(auth) for :identity provider" do
    setup do
      user = insert_user_with_password("dummyPassword")
      {:ok, user: user}
    end

    test "authenticates user with valid credentials", %{user: %User{id: id} = user} do
      auth = auth_struct(:identity, user.email, "dummyPassword")
      assert {:ok, %User{id: ^id}} = Auth.authenticate(auth)
    end

    test "rejects on invalid credentials", %{user: user} do
      auth = auth_struct(:identity, user.email, "wrong")
      assert {:error, _reason} = Auth.authenticate(auth)

      auth = auth_struct(:identity, "mail@b.cc", "dummyPassword")
      assert {:error, _reason} = Auth.authenticate(auth)
    end
  end

  describe "authenticate(auth) for non-identity provider" do
    setup do
      user = insert(:google_user)
      {:ok, user: user}
    end

    test "authenticates user with valid credentials", %{user: %User{id: id} = user} do
      auth = auth_struct(:google, user.email, user.uid)
      assert {:ok, %User{id: ^id}} = Auth.authenticate(auth)
    end
  end
end
