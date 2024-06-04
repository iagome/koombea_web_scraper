defmodule KoombeaWebScraper.WebsitesTest do
  use KoombeaWebScraper.DataCase
  use Mimic

  import KoombeaWebScraper.AccountsFixtures
  import KoombeaWebScraper.UrlsScraperFixtures

  alias KoombeaWebScraper.UrlsScraper
  alias KoombeaWebScraper.WebsiteComponents
  alias KoombeaWebScraper.Websites

  describe "create/2" do
    test "create a website and its components successfully, returns :ok" do
      user = user_fixture()
      url = "https://google.com"

      expect(UrlsScraper, :scrape_and_parse_url, fn _ ->
        {:ok, "Google", scrape_n_sanitized_fixture()}
      end)

      assert {:ok, website} = Websites.create(url, user.id)

      assert website.total_links == 3
      assert website.url == url

      assert [_, _, _] = WebsiteComponents.get_by_website_id(website.id)
    end

    test "create a website and its components successfully with messed data from scraper, returns :ok" do
      user = user_fixture()
      url = "https://github.com"

      expect(UrlsScraper, :scrape_and_parse_url, fn _ ->
        {:ok, "Github", scrape_unsanitized_fixture()}
      end)

      assert {:ok, website} = Websites.create(url, user.id)

      assert website.total_links == 3
      assert website.url == url

      assert [_, _, _] = WebsiteComponents.get_by_website_id(website.id)
    end

    test "create a website and its components but ignore empty data from scraper, returns :ok" do
      user = user_fixture()
      url = "https://github.com"

      expect(UrlsScraper, :scrape_and_parse_url, fn _ ->
        {:ok, "Github", scrape_empty_data_fixture()}
      end)

      assert {:ok, website} = Websites.create(url, user.id)

      assert website.total_links == 1
      assert website.url == url

      assert [_] = WebsiteComponents.get_by_website_id(website.id)
    end

    test "create a website but no components when none are valid, returns :ok" do
      user = user_fixture()
      url = "https://github.com"

      expect(UrlsScraper, :scrape_and_parse_url, fn _ ->
        {:ok, "Github", scrape_invalid_data_fixture()}
      end)

      assert {:ok, website} = Websites.create(url, user.id)

      assert website.total_links == 0
      assert website.url == url

      assert [] = WebsiteComponents.get_by_website_id(website.id)
    end

    test "create a website but no components when no link is found, returns :ok" do
      user = user_fixture()
      url = "https://github.com"

      expect(UrlsScraper, :scrape_and_parse_url, fn _ ->
        {:ok, "Github", []}
      end)

      assert {:ok, website} = Websites.create(url, user.id)

      assert website.total_links == 0
      assert website.url == url

      assert [] = WebsiteComponents.get_by_website_id(website.id)
    end
  end

  describe "get_by_user_id/1" do
    test "existing websites, returns websites" do
      user = user_fixture()
      website_1 = insert(:website, user_id: user.id)
      website_2 = insert(:website, user_id: user.id)

      assert [response_1, response_2] = Websites.get_by_user_id(user.id)
      assert response_1.id == website_1.id
      assert response_1.url == website_1.url

      assert response_2.id == website_2.id
      assert response_2.url == website_2.url
    end

    test "a nonexistent website, returns empty list" do
      assert [] == Websites.get_by_user_id(1234)
    end
  end

  describe "get/1" do
    test "an existing website, returns website" do
      user = user_fixture()
      website = insert(:website, user_id: user.id)

      assert response = Websites.get(website.id)
      assert response.id == website.id
      assert response.url == website.url
      assert response.user_id == website.user_id
    end

    test "a nonexistent website, returns nil" do
      assert nil == Websites.get(1234)
    end
  end
end
