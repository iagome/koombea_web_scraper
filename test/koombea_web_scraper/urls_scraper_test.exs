defmodule KoombeaWebScraper.UrlsScraperTest do
  use KoombeaWebScraper.DataCase
  use Mimic

  import KoombeaWebScraper.BodyScrapeFixtures

  alias KoombeaWebScraper.UrlsScraper

  describe "scrape_and_parse_url/1" do
    test "a valid url, returns success" do
      url = "https://medium.com/"
      body = valid_body_fixture()

      expect(Crawly, :fetch, fn _ ->
        %HTTPoison.Response{status_code: 200, body: body}
      end)

      assert {:ok, _page_title, _components} = UrlsScraper.scrape_and_parse_url(url)
    end

    test "a valid url with messed data, returns success" do
      url = "https://medium.com/"
      body = faulty_body_fixture()

      expect(Crawly, :fetch, fn _ ->
        %HTTPoison.Response{status_code: 200, body: body}
      end)

      assert {:ok, _page_title, components} = UrlsScraper.scrape_and_parse_url(url)
      assert [component_1, component_2, component_3] = components
      assert component_1.url == ""
      assert component_2.name =~ "Kafka"
      assert component_3.url == "/Idempotence"
    end

    test "an invalid url, returns error" do
      url = "bad website"
      body = error_body_fixture()

      expect(Crawly, :fetch, fn _ ->
        %HTTPoison.Response{status_code: 404, body: body}
      end)

      assert {:error, :error_fetching_url} = UrlsScraper.scrape_and_parse_url(url)
    end
  end
end
