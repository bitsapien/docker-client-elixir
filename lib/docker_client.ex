defmodule DockerClient do
  @moduledoc """
  Documentation for DockerClient.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DockerClient.hello()
      :world

  """

  def connection(uri) do
    parsed_uri = URI.parse(uri)
  end

  def docker_config do
    {:ok, config} = YamlElixir.read_from_file("./v1.40.yaml")
    config
  end

  def config_paths do
    docker_config["paths"]
  end

  def extract_category(path) do
    Enum.at(String.split(path, "/"), 1)
  end

  def categories do
    config_paths
    |> Map.keys()
    |> Enum.map(&extract_category(&1))
    |> MapSet.new()
  end

  def of_category?(operation, category) do
    extract_category(elem(operation, 0)) == category
  end

  def ops(category) do
    config_paths
    |> Enum.filter(&of_category?(&1, category))
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.map(fn x -> Enum.at(Map.values(x), 0)["operationId"] end)
  end
end
