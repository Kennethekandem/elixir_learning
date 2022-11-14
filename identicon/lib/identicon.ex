defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> color_picker
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image input

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
    grid =
      hex
      # get the hex [124, 169, 85, ...] and chunk it into a list of lists with 3 numbers a list. Example [[124, 169, 85], [...]]
      |> Enum.chunk(3)
      # map through the chunked list [[124, 169, 85], [...]] and then call on the `mirror_row` function
      |> Enum.map(&mirror_row/1)
      # merge the list of lists into one list. Example, [[124, 169, 85, 169, 124], [...]] to [124, 169, 85, 169, 124, ...]
      |> List.flatten
      # index the list. Example, [124, 169, 85, 169, 124, ...] to [{124, 0}, {169, 1}, {85, 2}, {169, 3}, {124, 4}, ...]
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
    Enum.filter grid, fn({code, _} = square)  ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn ({_, index}) ->
      horiontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = {horiontal, vertical}
      bottom_right = {horiontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn ({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

end
