defmodule HolidayApp.Holidays.HolidayTest do
  use HolidayApp.DataCase

  alias HolidayApp.Holidays.Holiday

  describe "changeset(holiday, attrs)" do
    test "valid attributes" do
      attrs = params_for(:holiday)
      changeset = Holiday.changeset(%Holiday{}, attrs)
      assert changeset.valid?
    end

    test "requires title" do
      attrs = params_for(:holiday, title: "")
      changeset = Holiday.changeset(%Holiday{}, attrs)
      refute changeset.valid?
      assert {
        :title, { "can't be blank", [validation: :required] }
      } in changeset.errors
    end

    test "does not accept short titles" do
      attrs = params_for(:holiday, title: "Yo")
      changeset = Holiday.changeset(%Holiday{}, attrs)
      refute changeset.valid?
    end

    test "does not accept long titles" do
      attrs = params_for(:holiday, title: String.duplicate("a", 65))
      changeset = Holiday.changeset(%Holiday{}, attrs)
      assert "should be at most 64 character(s)" in errors_on(changeset).title
    end

    test "validates kind in [holiday, workday]" do
      attrs = params_for(:holiday, kind: "day off")
      changeset = Holiday.changeset(%Holiday{}, attrs)
      assert "is invalid" in errors_on(changeset).kind

      attrs = params_for(:holiday, kind: "holiday")
      changeset = Holiday.changeset(%Holiday{}, attrs)
      assert changeset.valid?

      attrs = params_for(:holiday, kind: "workday")
      changeset = Holiday.changeset(%Holiday{}, attrs)
      assert changeset.valid?
    end

    test "validates date" do
      attrs = params_for(:holiday, date: "2018-02-30")
      changeset = Holiday.changeset(%Holiday{}, attrs)
      assert "is invalid" in errors_on(changeset).date
    end
  end
end
