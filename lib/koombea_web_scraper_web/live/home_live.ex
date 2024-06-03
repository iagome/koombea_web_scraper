defmodule KoombeaWebScraperWeb.HomeLive do
  use KoombeaWebScraperWeb, :live_view

  alias KoombeaWebScraper.Websites
  alias KoombeaWebScraper.Websites.Website

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Web Scraper
      <:subtitle>Scrape any pages on the web for Links</:subtitle>
    </.header>
    <.simple_form for={@form} id="scrape_website_form" phx-submit="scrape" phx-change="validate">
      <.input field={@form[:url]} type="text" label="URL" required />
      <:actions>
        <.button phx-disable-with="Scraping..." class="w-full">
          Scrape
        </.button>
      </:actions>
    </.simple_form>
    <.table id="websites" rows={@websites}>
      <:col :let={website} label="Name"><%= website.name %></:col>
      <:col :let={website} label="Total Links"><%= website.total_links %></:col>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    attrs = %{user_id: socket.assigns.current_user.id, url: ""}

    form_source = Website.changeset(%Website{}, attrs)

    form = to_form(form_source)
    website = [%{name: "Teste", total_links: 12}]

    {:ok, assign(socket, form: form, websites: website)}
  end

  def handle_event("validate", %{"website" => %{"url" => url}}, socket) do
    case Website.validate_url_changeset(%Website{}, %{url: url}) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}

      changeset ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
    end
  end

  def handle_event("scrape", %{"website" => %{"url" => url}}, socket) do
    Websites.create(url, socket.assigns.current_user.id)

    {:noreply,
     socket
     |> put_flash(:info, "URL is being scraped")
     |> redirect(to: ~p"/")}
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source))
  end
end
