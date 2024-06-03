defmodule KoombeaWebScraper.UrlsScraperFixtures do
  @moduledoc """
  This module defines test helpers for Url scrapers
  """

  def scrape_n_sanitized_fixture(n \\ 3) do
    for _ <- 1..n do
      %{
        url: "https://website#{n}.com",
        name: "Website #{n}"
      }
    end
  end

  def scrape_unsanitized_fixture do
    [
      %{
        url: "/features/packages",
        name: " Packages Host and manage packages    \n"
      },
      %{
        url: "/features/actions",
        name: "        Actions Automate \n     any workflow       "
      },
      %{
        url: "/features/security",
        name: "    Security Find and    fix vulnerabilities \n      "
      }
    ]
  end

  def scrape_empty_data_fixture do
    [
      %{
        url: "",
        name: " Packages Host and manage packages    \n"
      },
      %{
        url: "/features/actions",
        name: ""
      },
      %{
        url: "https://github.com/features/security",
        name: "    Security Find and    fix vulnerabilities \n      "
      }
    ]
  end

  def scrape_invalid_data_fixture do
    [
      %{
        url: "",
        name: " Packages Host and manage packages    \n"
      },
      %{
        url: "/features/actions",
        name: ""
      },
      %{
        url: "features#security",
        name: "    Security Find and    fix vulnerabilities \n      "
      }
    ]
  end
end
