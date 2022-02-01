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
          "scope" => scope
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
      "moduleName" => scope
    }
    |> put_if_valid("columnStart", get_val("column", issue))
    |> put_if_valid("columnEnd", get_val("column_end", issue))
    |> put_if_valid("origin", get_val("trigger", issue))
  end

  defp put_if_valid(map, _key_name, :invalid), do: map
  defp put_if_valid(map, key_name, value), do: Map.put(map, key_name, value)

  defp get_val("column_end", %{"column_end" => column_end}) when is_integer(column_end),
    do: column_end

  defp get_val("column_end", %{"column" => column}) when is_integer(column), do: column
  defp get_val("column_end", _), do: :invalid

  defp get_val("column", %{"column" => column}) when is_integer(column), do: column
  defp get_val("column", _), do: :invalid

  defp get_val("trigger", %{"trigger" => trigger}) when is_bitstring(trigger), do: trigger
  defp get_val("trigger", _), do: :invalid

  defp get_val(value_name, issue), do: Map.get(issue, value_name, :invalid)
end
