defmodule CredoJenkins do
  alias CredoJenkins.IssueTransformer

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
      |> IssueTransformer.transform()
      |> Jason.encode!()
    end)
    |> write_credo_report!(output_path)
  end

  defp read_credo_report!(report_path) do
    {:ok, body} = File.read(report_path)
    %{"issues" => issues} = Jason.decode!(body)
    issues
  end

  defp write_credo_report!(report, output_path) do
    File.write(output_path, report)
  end
end
