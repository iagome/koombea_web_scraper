defmodule KoombeaWebScraperWeb.WebsiteComponentsLive do
  use KoombeaWebScraperWeb, :live_view

  alias KoombeaWebScraper.WebsiteComponents
  alias KoombeaWebScraper.Websites

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      <%= @page_title %>
    </.header>
    <.back navigate={~p"/"}>Back</.back>
    <.table id="website_components" rows={@components}>
      <:col :let={component} label="Name"><%= component.name %></:col>
      <:col :let={component} label="URL"><%= component.url %></:col>
    </.table>
    """
  end

  def mount(%{"website_id" => website_id}, _session, socket) do
    website = Websites.get(website_id)

    components = WebsiteComponents.get_by_website_id(website_id)

    {:ok, assign(socket, components: components, page_title: website.name)}
  end
end
