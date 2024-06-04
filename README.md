# Web Scraper

A Web Scraping solution with login and a minimalist Front-end that enables you to quickly scrape any website for all the links it holds.

## Dependencies

- Docker (>= 26.1.1)
- Elixir (~> 1.16.1)
- Erlang/OTP (~> 24.3.4.9)

## Tools

- [mix phx.gen.auth](https://hexdocs.pm/phoenix/mix_phx_gen_auth.html) to generate the authentication solution and needed files;
- [Crawly](https://github.com/elixir-crawly/crawly) for the web scraping;
- [Floki](https://github.com/philss/floki) to parse HTML pages;
- [Credo](https://github.com/rrrene/credo) for static code analysis (syntax);
- [Dialyxir](https://github.com/jeremyjh/dialyxir) for static code analysis (semantics and syntax);
- [ExMachina](https://github.com/beam-community/ex_machina) for test factories;
- [Mimic](https://github.com/edgurgel/mimic) for testing with Mocks.

## Running the project

### Running Docker

Run the following command to start building your Docker environment (it may take a few minutes to build everything):
```bash
docker compose build
```

Once your environment is setup, you can install the project's dependencies:
```bash
docker compose run --rm koombea_web_scraper mix deps.get
```

After that, let's create our database, run all the migrations and run seeds:
```bash
docker compose run --rm koombea_web_scraper mix ecto.setup
```

With all that done, you can run the project with:
```bash
docker compose up
```

### Other useful Docker commands

Runs new migrations (if there are any):
```bash
docker compose run --rm koombea_web_scraper mix ecto.migrate
```

Rollback the last migration that was ran:
```bash
docker compose run --rm koombea_web_scraper mix ecto.rollback
```

Runs all tests:
```bash
docker compose run --rm koombea_web_scraper mix test
```

Runs all quality code commands (check for fomatting, runs credo and dialyzer):
```bash
docker compose run --rm koombea_web_scraper mix quality
```

Drops and creates a fresh database:
```bash
docker compose run --rm koombea_web_scraper mix ecto.reset
```

## Usage Example

As soon as the project is running, you can access it at: http://localhost:4000 and you will be redirected to the login page if you're not logged in yet, since the home page is only available if you're logged in.

You will see the following page:
![login](https://github.com/iagome/koombea_web_scraper/assets/26315886/5ad8e30a-4bb7-4d8f-9f48-d8a1aa17dc55)

If you still don't have an account, you can click on the `Sign up` link at the top of the page or on the `Register` button at the top right corner of the page.

When you click on either, you will see the following page:
![signup](https://github.com/iagome/koombea_web_scraper/assets/26315886/194fee86-91e6-4228-a89f-0b70c735bf35)

You can now create your account by typing your e-mail and desired password. Be aware that the password must be at least 10 characters long.

As soon as you insert your credentials and create your account, you'll be logged in automatically and will have access to the home page and will see the following page:

![home](https://github.com/iagome/koombea_web_scraper/assets/26315886/ed2deed0-ef4d-4534-8a3e-de57421f6c04)

Here we have a few different elements:
- An input field, where you can type the website you want to scrape;
- The scrape button, to start the scraping process;
- The (still empty) table with all the websites you scraped and how many links it found on that website.

Now, let's say you want to scrape the Elixir page on Wikipedia. As you start typing the URL on the field, it will say that the URL is not valid, since there is a validation for valid URLs, that runs on every character you type on the field, and it only vanishes when the URL is valid.

![invalid-url](https://github.com/iagome/koombea_web_scraper/assets/26315886/8d0f4b74-7913-4b95-ac50-e56355e4bd1e)

When we have a valid URL, the error vanishes and we can scrape it:

![valid-url](https://github.com/iagome/koombea_web_scraper/assets/26315886/2a25c7e0-9472-465d-9c65-91a04642a5b7)

Once we press the scrape button, since it's an asynchronous work, the page won't have any change, until the server has done all the work, then the table will be updated with the newly scraped page and the total links the page had.

![scraped-page](https://github.com/iagome/koombea_web_scraper/assets/26315886/87bc1f6d-cdc3-480c-aa09-5616df456912)

Once that's done, we can click on any page we have scraped to open up a new page where we can see all the links that have been scraped from that website.

![links-from-scraped](https://github.com/iagome/koombea_web_scraper/assets/26315886/bcb11cd3-391f-473f-a6bc-01d5c1692449)

With that, we can even click on any link on this page to be redirected to that link. For example, if I click on the `Help` link that has been scraped, I will be redirected to the Elixir Help content on Wikipedia.

![click-on-scraped-link](https://github.com/iagome/koombea_web_scraper/assets/26315886/9eb5578d-1241-42cf-bfaf-b806ffa01a9c)

There is also a `Back` button on the top left corner of the table, which we can use to return to the home page and scrape more pages for links.

Finally, we can have as many scraped websites as we like:

![final-scrapes](https://github.com/iagome/koombea_web_scraper/assets/26315886/657e9e0a-c4e9-466b-b0f4-2abb5436c837)

## Improvements

- Improve Dockerfile with production settings, like adding and setting up timezone control, installing dependencies and libs etc, along with a .dockerignore file to avoid sending large or sensitive files and directories to the daemon;
- Having a `.env` file to work with environment variables safer;
- Add a CI/CD pipeline to prevent faulty code and errors going to production;
- Have a pagination solution using Scrivener at first, to improve performance. And as the project grows, it would be nice to have a pagination using cursors, since using Scrivener can become slow if there are too many data in the database;
- See the pages that are still being scraped on the table, instead of using the <.table> live view element, create a <table> with the HTML syntax and run throw rows manually, therefore giving the developer more flexibility.
