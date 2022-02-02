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

  ## Examples:

    iex> CredoJenkins.run("credo.json", "credo.log")
    :ok
  """
  def run(input_path, output_path) do
    input_path
    |> read_credo_report!()
    |> transform()
    |> dummy_report_if_empty()
    |> write_credo_report!(output_path)
  end

  @doc """
  Takes an array of Credo issue maps and reduces them
  into a string that Jenkins can later read.

  ## Examples

      iex> CredoJenkins.transform([])
      ""

      iex> transform([%{...}, %{...}])
      "{...} {...}"
  """
  def transform(credo_report),
    do:
      Enum.map_join(credo_report, "\n", fn item ->
        item
        |> IssueTransformer.transform()
        |> Jason.encode!()
      end)

  @doc """
  Reads and parses the Credo output from a given file on disk.
  Will raise if the file dows not exist or if it is not a proper
  JSON formatted Credo report.

  ## Examples

      iex> CredoJenkins.read_credo_report!("credo.json")
      []

      iex> CredoJenkins.read_credo_report!("credo.xml")
      Jason.DecodeError
  """
  def read_credo_report!(report_path) do
    {:ok, body} = File.read(report_path)
    %{"issues" => issues} = Jason.decode!(body)
    issues
  end

  defp dummy_report_if_empty(""), do: "// end"
  defp dummy_report_if_empty(report), do: report

  defp write_credo_report!(report, output_path), do: File.write(output_path, report)
end
