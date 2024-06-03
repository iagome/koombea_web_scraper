defmodule KoombeaWebScraper.WebsiteComponentFactory do
  @moduledoc """
  Responsible for the website components table factory
  """

  alias KoombeaWebScraper.Websites.WebsiteComponent

  defmacro __using__(_opts) do
    quote do
      def website_component_factory do
        %WebsiteComponent{
          url: "https://website#{:rand.uniform(9_999)}",
          name: "Website #{:rand.uniform(9_999)}",
          website: build(:website)
        }
      end
    end
  end
end
