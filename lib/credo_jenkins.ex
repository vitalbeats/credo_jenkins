defmodule CredoJenkins do
  @moduledoc """
  Reads a credo report in a json format
  (`mix credo --strict --format json > credo.json`)
  and transforms it into a format that Jenkins can natively understand.

  As seen in: https://github.com/jenkinsci/warnings-ng-plugin/blob/master/plugin/src/test/resources/io/jenkins/plugins/analysis/warnings/steps/json-issues.log

  In theory it would be better if we called credo programatically,
  but for the time being this will do the trick.
  """

  @doc """
  Reads a credo json report from a given path, transforms it
  and outputs to a given path.

  ## Examples

      iex> CredoJenkins.transform("credo.json", "credo.log")
      :ok
  """
  def transform(input_path, output_path) do
    read_credo_report!(input_path)
    |> Enum.map_join("\n", fn item ->
      item
      |> transform_issue()
      |> Jason.encode!()
    end)
    |> write_credo_report!(output_path)
  end

  @doc """
  Transforms a single Credo issue item into a format
  that Jenkins can natively read.

  We mark all as "error" severity as Credo does not offer severity levels.
  """
  def transform_issue(%{
        "category" => category,
        "check" => check,
        "column" => column,
        "column_end" => column_end,
        "filename" => filename,
        "line_no" => line_no,
        "message" => message,
        "scope" => scope,
        "trigger" => trigger
      }),
      do: %{
        "fileName" => filename,
        "severity" => "ERROR",
        "lineStart" => line_no,
        "lineEnd" => line_no,
        "columnStart" => column,
        "columnEnd" => column_end,
        "message" => check,
        "description" => message,
        "category" => category,
        "moduleName" => scope,
        "origin" => trigger
      }

  defp read_credo_report!(report_path) do
    {:ok, body} = File.read(report_path)
    %{"issues" => issues} = Jason.decode!(body)
    issues
  end

  defp write_credo_report!(report, output_path) do
    File.write(output_path, report)
  end
end
