defmodule CredoJenkins.IssueTransformer do
  @moduledoc """
  Transforms a single Credo issue item into a format
  that Jenkins can natively read.
  """

  @doc """
  Transforms a single Credo issue item into a format
  that Jenkins can natively read.

  We mark all as "error" severity as Credo does not offer severity levels.
  """
  def transform(
        %{
          "category" => category,
          "check" => check,
          "filename" => filename,
          "line_no" => line_no,
          "message" => message,
          "scope" => scope,
          "trigger" => trigger
        } = issue
      ) do
    %{
      "fileName" => filename,
      "severity" => "ERROR",
      "lineStart" => line_no,
      "lineEnd" => line_no,
      "message" => check,
      "description" => message,
      "category" => category,
      "moduleName" => scope,
      "origin" => trigger
    }
    |> put_if_valid("columnStart", get_val("column", issue))
    |> put_if_valid("columnEnd", get_val("column_end", issue))
  end

  defp put_if_valid(map, _key_name, :invalid), do: map
  defp put_if_valid(map, key_name, value), do: Map.put(map, key_name, value)

  defp get_val("column_end", %{"column_end" => column_end}) when is_integer(column_end),
    do: {:ok, column_end}

  defp get_val("column_end", %{"column" => column}) when is_integer(column), do: {:ok, column}
  defp get_val("column_end", _), do: :invalid

  defp get_val("column", %{"column" => column}) when is_integer(column), do: {:ok, column}
  defp get_val("column", _), do: :invalid
end
