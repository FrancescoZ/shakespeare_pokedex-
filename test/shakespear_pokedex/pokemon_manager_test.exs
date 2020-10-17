defmodule ShakespearePokedex.PokemonManagerTest do
  import Mox
  use ShakespearePokedex.DataCase
  use ExUnit.Case, async: false

  @pokemon_name "testMeEasly"
  @pokemon_id "123"
  @valid_pokemon %{
    name: @pokemon_name,
    id: @pokemon_id,
    abilities: ["blaze", "solar-power"]
  }
  @valid_pokemon_no_abilities %{
    name: @pokemon_name,
    id: @pokemon_id,
    abilities: ["nothing"]
  }
  @pokemon_error {:error, "invalid pokemon"}

  @valid_species [
    "When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs."
  ]
  @valid_characteristic ["Loves to eat"]
  @valid_color "black"
  @invalid_color "unknonw"
  @empty {:ok, []}

  @api ShakespearePokedex.PokemonApiMock
  @subject ShakespearePokedex.PokemonManager

  describe "get_info when pokemon" do
    test "is available returns a pokemon name and a description" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is black. Loves to eat . It can do: solar-powerblaze . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs."
             }
    end

    test "is available returns a pokemon name and a description even without abilities" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_no_abilities}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is black. Loves to eat . It can do: nothing . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs."
             }
    end

    test "is not available returns an error" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        @pokemon_error
      end)

      assert @subject.get_info(@pokemon_name) == {:error, "invalid pokemon"}
    end

    test "is available and the rest is not it returns a pokemon name and a description" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is unknonw.  . It can do: solar-powerblaze . It is "
             }
    end
  end

  describe "get_info when color" do
    test "is available it returns a pokemon name and description with it" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is black.  . It can do: solar-powerblaze . It is "
             }
    end

    test "is not available returns a pokemon name and description with unknown color" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is unknonw. Loves to eat . It can do: solar-powerblaze . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs."
             }
    end
  end

  describe "get_info when species" do
    test "is available it returns a pokemon name and description with it" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is unknonw.  . It can do: solar-powerblaze . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs."
             }
    end

    test "is not available it returns a pokemon name and description without any species" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is black.  . It can do: solar-powerblaze . It is "
             }
    end
  end

  describe "get_info when abilities" do
    test "is available returns a pokemon name and a description" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is unknonw.  . It can do: solar-powerblaze . It is "
             }
    end
  end

  describe "get_info when description" do
    test "is available it returns a pokemon name and description with it" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is unknonw. Loves to eat . It can do: solar-powerblaze . It is "
             }
    end

    test "is not available it returns a pokemon name and description without any species" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description:
                 "testMeEasly. Its color is unknonw.  . It can do: solar-powerblaze . It is "
             }
    end
  end
end
