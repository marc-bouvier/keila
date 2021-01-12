defmodule Keila.Contacts.Query do
  @moduledoc """
  Module for querying Contacts.

  The `apply/2` function takes two arguments: a query (`Ecto.Query.t()`) and options
  for filtering and sorting the resulting data set.

  ## Filtering
  Using the `:filter` option, you can supply a MongoDB-style query map.

  ### Supported operators:
  - `"$not"` - logical not.
     `%{"$not" => {%"email" => "foo@bar.com"}}`
  - `"$or"` - logical or.
     `%{"$or" => [%{"email" => "foo@bar.com"}, %{"inserted_in" => "2020-01-01 00:00:00Z"}]}`
  - `"$gt"` - greater-than operator.
    `%{"inserted_at" => %{"$gt" => "2020-01-01 00:00:00Z"}}`
  - `"$gte"` - greater-than-equal operator.
  - `"$lt"` - lesser-than operator.
    `%{"inserted_at" => %{"$lt" => "2020-01-01 00:00:00Z"}}`
  - `"$lte"` - lesser-than-or-equal operator.
  - `"$in"` - queries if field value is part of a set.
     `%{"email" => %{"$in" => ["foo@example.com", "bar@example.com"]}}`

  ## Sorting
  Using the `:sort` option, you can supply MongoDB-style sorting options:
  - `filter: %{"email" => 1}` will sort results by email in ascending order.
  - `filter: %{"email" => -1}` will sort results by email in descending order.

  Defaults to sorting by `inserted_at`.
  """

  use Keila.Repo

  @fields ["email", "inserted_at", "first_name", "last_name"]

  @spec apply(Ecto.Query.t(), filter: map(), sort: map()) :: Ecto.Query.t()
  def apply(query, opts) do
    query
    |> maybe_filter(opts)
    |> sort(opts)
  end

  defp maybe_filter(query, opts) do
    case Keyword.get(opts, :filter) do
      input when is_map(input) -> filter(query, input)
      _ -> query
    end
  end

  defp filter(query, input) do
    from(q in query, where: ^build_and(input))
  end

  defp build_and(input) do
    Enum.reduce(input, nil, fn {k, v}, conditions ->
      condition = build_condition(k, v)

      if conditions == nil,
        do: condition,
        else: dynamic([c], ^condition and ^conditions)
    end)
  end

  defp build_or(input) do
    Enum.reduce(input, nil, fn input, conditions ->
      condition = build_and(input)

      if conditions == nil,
        do: condition,
        else: dynamic([c], ^condition or ^conditions)
    end)
  end

  defp build_condition("$or", input),
    do: build_or(input)

  defp build_condition("$not", input),
    do: dynamic(not (^build_and(input)))

  defp build_condition(field, input) when field in @fields,
    do: build_condition(String.to_existing_atom(field), input)

  defp build_condition(field, %{"$gt" => value}),
    do: dynamic([c], field(c, ^field) > ^value)

  defp build_condition(field, %{"$gte" => value}),
    do: dynamic([c], field(c, ^field) >= ^value)

  defp build_condition(field, %{"$lt" => value}),
    do: dynamic([c], field(c, ^field) < ^value)

  defp build_condition(field, %{"$lte" => value}),
    do: dynamic([c], field(c, ^field) <= ^value)

  defp build_condition(field, %{"$in" => value}) when is_list(value),
    do: dynamic([c], field(c, ^field) in ^value)

  defp build_condition(field, value) when value in ["null", nil],
    do: dynamic([c], is_nil(field(c, ^field)))

  defp build_condition(field, value) when is_binary(value) or is_number(value) or is_nil(value),
    do: dynamic([c], field(c, ^field) == ^value)

  defp build_condition(field, value),
    do: raise(~s{Unsupported filter "#{field}": "#{inspect(value)}"})

  defp sort(query, opts) do
    {sort_field, direction} =
      Keyword.get(opts, :sort, %{"inserted_at" => 1})
      |> Map.take(@fields)
      |> Map.to_list()
      |> List.first()

    sort_field = String.to_existing_atom(sort_field)
    direction = if direction == -1, do: :desc, else: :asc

    order_by(query, [c], {^direction, field(c, ^sort_field)})
  end
end