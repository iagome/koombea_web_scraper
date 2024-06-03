defmodule KoombeaWebScraper.WebsiteComponentsTest do
  use KoombeaWebScraper.DataCase

  import KoombeaWebScraper.AccountsFixtures

  alias KoombeaWebScraper.WebsiteComponents

  describe "batch_create/2" do
    test "create website components in batch, returns success" do
      user = user_fixture()
      website = insert(:website, user_id: user.id)

      attrs = [
        %{name: "Website1", url: "https://website1.com"},
        %{name: "Website2", url: "https://website2.com"}
      ]

      assert {2, nil} = WebsiteComponents.batch_create(attrs, website.id)
    end
  end

  describe "get_by_website_id/1" do
    test "existing website components, returns website components" do
      user = user_fixture()
      website = insert(:website, user_id: user.id)
      component_1 = insert(:website_component, website: website)
      component_2 = insert(:website_component, website: website)
      insert(:website_component)

      assert [response_1, response_2] = WebsiteComponents.get_by_website_id(website.id)
      assert response_1.id == component_1.id
      assert response_1.url == component_1.url

      assert response_2.id == component_2.id
      assert response_2.url == component_2.url
    end

    test "a nonexistent website component, returns empty list" do
      assert [] == WebsiteComponents.get_by_website_id(1234)
    end
  end
end
