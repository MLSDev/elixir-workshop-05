defmodule HolidayApp.UsersTest do
  use HolidayApp.DataCase

  alias HolidayApp.Users
  alias HolidayApp.Users.User

  describe "list_users/0" do
    test "returns all users" do
      insert_pair(:user)

      assert [%User{}, %User{}] = Users.list_users()
    end
  end

  describe "get_user!/1" do
    test "finds user by id" do
      %User{id: id} = insert(:user)

      assert %User{id: ^id} = Users.get_user!(id)
    end
  end

  describe "find_by_email_and_password/2" do
    setup do
      user =
        %User{}
        |> User.create_changeset(params_for(:user))
        |> Ecto.Changeset.apply_changes()
        |> insert()

      {:ok, user: user}
    end

    test "returns {:ok, user} on valid email and password", %{user: user} do
      assert {:ok, %User{id: id}} = Users.find_by_email_and_password(user.email, "P4$$w0rd")
      assert id == user.id
    end

    test "returns {:error, reason} on invalid credentials", %{user: user} do
      assert {:error, reason} = Users.find_by_email_and_password(user.email, "password")
      assert is_binary(reason)
    end

    test "returns {:error, reason} on empty credentials" do
      assert {:error, _reason} = Users.find_by_email_and_password(nil, nil)
    end
  end

  describe "create_or_update_user/1" do
    test "creates new user if one does not exist" do
      attrs = params_for(:google_user)
      {:ok, %User{} = user} = Users.create_or_update_user(attrs)
      assert user.email == attrs.email
    end

    test "returns existing user" do
      attrs = params_for(:google_user)
      existing_user = build(:google_user, attrs) |> insert()

      {:ok, user} = Users.create_or_update_user(attrs)
      assert user.id == existing_user.id
    end

    test "updates provider and uid fields" do
      attrs = params_for(:user, %{uid: nil})

      %User{id: id} = user = build(:user, attrs) |> insert()
      assert user.provider == "identity"
      assert user.uid == nil

      attrs = Map.merge(attrs, %{provider: "google", uid: "abc123"})

      {:ok, %User{id: ^id} = user} = Users.create_or_update_user(attrs)
      assert user.provider == "google"
      assert user.uid == "abc123"
    end
  end
end
