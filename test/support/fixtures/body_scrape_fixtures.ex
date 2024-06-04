defmodule KoombeaWebScraper.BodyScrapeFixtures do
  @moduledoc """
  This module defines test helpers for body requests
  """

  def valid_body_fixture do
    ~S(
      <head>
        <title>Kafka - Idempotent Producer and Consumer</title>
      </head>
      <a href="https://medium.com">Medium</a>
      <a href="https://kafka.apache.org/">Apache Kafka</a>
      <a href="https://en.wikipedia.org/wiki/Idempotence">Idempotence</a>
    )
  end

  def faulty_body_fixture do
    ~S(
      <head>
        <title>Kafka - Idempotent Producer and Consumer</title>
      </head>
      <a href="">Medium</a>
      <a href="https://kafka.apache.org/">
        Apache Kafka
      </a>
      <a href="/Idempotence">Idempotence</a>
    )
  end

  def error_body_fixture do
    "Generic error - Page not found"
  end
end
