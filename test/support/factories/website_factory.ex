defmodule KoombeaWebScraper.WebsiteFactory do
  @moduledoc """
  Responsible for the websites table factory
  """

  alias KoombeaWebScraper.Websites.Website

  defmacro __using__(_opts) do
    quote do
      def website_factory do
        %Website{
          url: "https://website#{:rand.uniform(9_999)}",
          name: "Website #{:rand.uniform(9_999)}",
          total_links: :rand.uniform(9_999)
        }
      end
    end
  end
end
