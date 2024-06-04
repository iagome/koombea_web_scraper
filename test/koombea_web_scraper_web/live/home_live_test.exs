defmodule KoombeaWebScraperWeb.HomeLiveTest do
  use KoombeaWebScraperWeb.ConnCase, async: true

  import KoombeaWebScraper.AccountsFixtures
  import Phoenix.LiveViewTest

  describe "Home page" do
    test "renders home page if user is logged in", %{conn: conn} do
      password = "123456789abcd"
      user = user_fixture(%{password: password})

      {:ok, lv, _html} = live(conn, ~p"/users/log_in")

      form =
        form(lv, "#login_form", user: %{email: user.email, password: password, remember_me: true})

      conn = submit_form(form, conn)

      assert redirected_to(conn) == ~p"/"

      {:ok, _lv, html} = live(conn, ~p"/")

      assert html =~ "Web Scraper"
      assert html =~ "Scrape any pages on the web for Links"
    end

    test "redirects to login page if user isn't logged in", %{conn: conn} do
      {:error, lv} = live(conn, ~p"/")

      assert {:redirect,
              %{to: "/users/log_in", flash: %{"error" => "You must log in to access this page."}}} =
               lv
    end
  end
end
