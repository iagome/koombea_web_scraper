defmodule KoombeaWebScraper.UrlsScraper do
  @moduledoc """
  Responsible for scraping URLs
  """

  require Logger

  @doc """
    Scrape any URL and parse the needed info

    ## Examples

        iex> scrape_and_parse_url("https://google.com")
        {:ok, "Google", [%{url: url, name: name}]}

        iex> scrape_and_parse_url(bad_url)
        {:error, :error_fetching_url}
  """
  @spec scrape_and_parse_url(String.t()) ::
          {:ok, String.t(), list()} | {:error, :error_fetching_url} | any()
  def scrape_and_parse_url(url) do
    with %HTTPoison.Response{status_code: 200, body: body} <- Crawly.fetch(url),
         page_title <- parse_page_title!(body),
         components <- parse_components!(body) do
      {:ok, page_title, components}
    else
      %HTTPoison.Response{status_code: status, body: body} ->
        Logger.error(
          "#{__MODULE__} - Error fetching URL with status code: #{inspect(status)} and reason: #{inspect(body)}"
        )

        {:error, :error_fetching_url}

      error ->
        Logger.error("#{__MODULE__} - An unexpected error occurred: #{inspect(error)}")
        error
    end
  end

  defp parse_page_title!(body) do
    body
    |> Floki.parse_document!()
    |> Floki.find("title")
    |> Floki.text()
  end

  defp parse_components!(body) do
    body
    |> Floki.parse_document!()
    |> Floki.find("a")
    |> Enum.map(fn tag ->
      %{
        url: tag |> Floki.attribute("href") |> Floki.text(),
        name: tag |> Floki.text() |> sanitize_name!()
      }
    end)
  end

  defp sanitize_name!(name) do
    name
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.join(" ")
    |> String.replace("\n", "")
  end
end
