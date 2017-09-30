defmodule Citybuilder.AddressesTest do
  use Citybuilder.DataCase

  alias Citybuilder.Addresses
  alias Citybuilder.Addresses.Country

  @create_attrs %{name: "some name", slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  def fixture(:country, attrs \\ @create_attrs) do
    {:ok, country} = Addresses.create_country(attrs)
    country
  end

  test "list_countries/1 returns all countries" do
    country = fixture(:country)
    assert Addresses.list_countries() == [country]
  end

  test "get_country! returns the country with given id" do
    country = fixture(:country)
    assert Addresses.get_country!(country.id) == country
  end

  test "create_country/1 with valid data creates a country" do
    assert {:ok, %Country{} = country} = Addresses.create_country(@create_attrs)
    assert country.name == "some name"
    assert country.slug == "some slug"
  end

  test "create_country/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Addresses.create_country(@invalid_attrs)
  end

  test "update_country/2 with valid data updates the country" do
    country = fixture(:country)
    assert {:ok, country} = Addresses.update_country(country, @update_attrs)
    assert %Country{} = country
    assert country.name == "some updated name"
    assert country.slug == "some updated slug"
  end

  test "update_country/2 with invalid data returns error changeset" do
    country = fixture(:country)
    assert {:error, %Ecto.Changeset{}} = Addresses.update_country(country, @invalid_attrs)
    assert country == Addresses.get_country!(country.id)
  end

  test "delete_country/1 deletes the country" do
    country = fixture(:country)
    assert {:ok, %Country{}} = Addresses.delete_country(country)
    assert_raise Ecto.NoResultsError, fn -> Addresses.get_country!(country.id) end
  end

  test "change_country/1 returns a country changeset" do
    country = fixture(:country)
    assert %Ecto.Changeset{} = Addresses.change_country(country)
  end
end
