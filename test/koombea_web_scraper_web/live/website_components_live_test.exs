defmodule KoombeaWebScraperWeb.WebsiteComponentsLiveTest do
  use KoombeaWebScraperWeb.ConnCase, async: true

  import KoombeaWebScraper.AccountsFixtures
  import Phoenix.LiveViewTest

  describe "details page" do
    test "renders the details page for a website", %{conn: conn} do
      password = "123456789abcd"
      user = user_fixture(%{password: password})
      website = insert(:website, user_id: user.id)
      component = insert(:website_component, website: website)

      {:ok, lv, _html} = live(conn, ~p"/users/log_in")

      form =
        form(lv, "#login_form", user: %{email: user.email, password: password, remember_me: true})

      conn = submit_form(form, conn)

      assert redirected_to(conn) == ~p"/"

      {:ok, _lv, html} = live(conn, ~p"/details/#{website.id}")

      assert html =~ website.name
      assert html =~ component.name
      assert html =~ component.url
    end

    test "redirects to login page if user isn't logged in", %{conn: conn} do
      {:error, lv} = live(conn, ~p"/details/1")

      assert {:redirect,
              %{to: "/users/log_in", flash: %{"error" => "You must log in to access this page."}}} =
               lv
    end
  end
end
