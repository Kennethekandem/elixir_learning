defmodule Cards do
  @moduledoc """
  Provides methods for creating a handling a deck of cards
  """

  @doc """
    Returns a list of strings representing a list of deck cards
  """
  def create_deck do
    values = ["ace", "two", "three", "Four", "five"]
    suits = ["spades", "clubs", "hearts", "diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end

  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines whether a deck contains a given card

  ## Example
      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "ace of spades")
      true
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
  @doc """
    Divides a deck into a hand and remainder of the deck. The `hand_size` argument indicates how many cards should be in the hand.

  ## Examples
      iex> deck = Cards.create_deck
      iex> {hand, _deck} = Cards.deal(deck, 1)
      iex> hand
      ["ace of spades"]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    # {status, binary} = File.read(filename)

    case File.read(filename) do
      {:ok, binary} ->
        :erlang.binary_to_term binary
      {:error, _reason} ->
        "That file does not exist"
    end
  end

  def create_hand(hand_size) do

    {head, _tail} =
    create_deck()
    |> shuffle()
    |> deal(hand_size)
    head
  end
end
