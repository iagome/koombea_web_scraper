defmodule KoombeaWebScraper.UrlsScraper do
  @moduledoc """
  Responsible for scraping URLs
  """

  def scrape_and_parse_url(url) do
    with %HTTPoison.Response{status_code: 200, body: body} <- Crawly.fetch(url),
         page_title <- parse_page_title!(body),
         components <- parse_components!(body) do
      {:ok, page_title, components}
    end
  end

  defp parse_page_title!(body) do
    body
    |> Floki.find("title")
    |> Floki.text()
  end

  defp parse_components!(body) do
    body
    |> Floki.parse_document!()
    |> Floki.find("a")
    |> Enum.map(fn tag ->
      %{
        url: Floki.attribute(tag, "href") |> Floki.text(),
        name: Floki.text(tag) |> sanitize_name!()
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
