defmodule Crawler.Fetcher.Retrier do
  @moduledoc """
  Handles retrying a failed crawl.
  """

  defmodule Spec do
    @moduledoc """
    Spec for defining a fetch retrier.
    """

    @type fetch_url :: fun
    @type opts      :: map

    @callback perform(fetch_url, opts) :: term
  end

  @behaviour __MODULE__.Spec

  use Retry

  def perform(fetch_url, opts) do
    retry with: exp_backoff() |> expiry(opts[:timeout]) do
      fetch_url.()
    end
  end
end