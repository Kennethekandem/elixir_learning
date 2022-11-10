defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> color_picker
    |> build_grid

  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def color_picker(image) do
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    hex
    # get the hex [124, 169, 85, ...] and chunk it into a list of lists with 3 numbers a list. Example [[124, 169, 85], [...]]
    |> Enum.chunk(3)
    # map through the chunked list [[124, 169, 85], [...]] and then call on the `mirror_row` function
    |> Enum.map(&mirror_row/1)
    # merge the list of lists into one list. Example, [[124, 169, 85, 169, 124], [...]] to [124, 169, 85, 169, 124, ...]
    |> List.flatten
    # index the list. Example, [124, 169, 85, 169, 124, ...] to [{124, 0}, {169, 1}, {85, 2}, {169, 3}, {124, 4}, ...]
    |> Enum.with_index
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

end
