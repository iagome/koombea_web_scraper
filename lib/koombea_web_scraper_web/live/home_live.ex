defmodule KoombeaWebScraperWeb.HomeLive do
  use KoombeaWebScraperWeb, :live_view
  use Phoenix.Component

  alias KoombeaWebScraper.Websites
  alias KoombeaWebScraper.Websites.Website

  alias Phoenix.LiveView.AsyncResult

  @impl true
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

  @impl true
  def mount(_params, _session, socket) do
    current_user_id = socket.assigns.current_user.id

    attrs = %{user_id: current_user_id, url: ""}

    form =
      %Website{}
      |> Website.changeset(attrs)
      |> to_form()

    websites = Websites.get_by_user_id(current_user_id)

    {:ok, assign(socket, form: form, websites: websites)}
  end

  def handle_event("validate", %{"website" => %{"url" => url}}, socket) do
    case Website.validate_url_changeset(%Website{}, %{url: url}) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}

      changeset ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
    end
  end

  @impl true
  def handle_event("scrape", %{"website" => %{"url" => url}}, socket) do
    current_user_id = socket.assigns.current_user.id

    {:noreply,
     socket
     |> assign(:async_result, AsyncResult.loading())
     |> start_async(:scrape_url, fn -> Websites.create(url, current_user_id) end)}
  end

  @impl true
  def handle_async(:scrape_url, {:ok, {:ok, website}}, %{assigns: assigns} = socket) do
    %{async_result: async_result, websites: websites} = assigns

    {:noreply,
     socket
     |> assign(:websites, [website | websites])
     |> put_flash(:info, "The URL has been scraped")
     |> assign(:async_result, AsyncResult.ok(async_result, website))}
  end

  @impl true
  def handle_async(:scrape_url, {:exit, reason}, socket) do
    %{async_result: async_result} = socket.assigns
    {:noreply, assign(socket, :websites, AsyncResult.failed(async_result, {:exit, reason}))}
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source))
  end
end
