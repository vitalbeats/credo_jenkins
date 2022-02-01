defmodule CredoJenkinsTest do
  use ExUnit.Case

  @moduledoc false

  # doctest CredoJenkins

  test "reads and outputs a file" do
    CredoJenkins.transform("test/fixtures/credo_ok.json", ".tmp/credo.report")
    assert {:ok, ""} = File.read(".tmp/credo.report")
  end

  test "raises when given an empty file" do
    assert_raise Jason.DecodeError, fn ->
      CredoJenkins.transform("test/fixtures/credo_empty.json", ".tmp/credo.report")
    end
  end

  test "raises when given an malformed file" do
    assert_raise Jason.DecodeError, fn ->
      CredoJenkins.transform("test/fixtures/credo_malformed.json", ".tmp/credo.report")
    end
  end

  test "reads and outputs a file with errors" do
    CredoJenkins.transform("test/fixtures/credo_errors.json", ".tmp/credo.report")
    assert {:ok, body} = File.read(".tmp/credo.report")

    assert [
             %{
               "category" => "readability",
               "description" =>
                 "Do not use parentheses when defining a function which has no arguments.",
               "fileName" => "lib/styx/api.ex",
               "lineEnd" => 38,
               "lineStart" => 38,
               "message" => "Credo.Check.Readability.ParenthesesOnZeroArityDefs",
               "moduleName" => "Styx.Api.mark",
               "origin" => "IO.inspect/1",
               "severity" => "ERROR",
               "columnEnd" => 12,
               "columnStart" => 1
             },
             %{
               "category" => "readability",
               "description" =>
                 "Do not use parentheses when defining a function which has no arguments.",
               "fileName" => "lib/styx/api.ex",
               "lineEnd" => 42,
               "lineStart" => 42,
               "message" => "Credo.Check.Readability.ParenthesesOnZeroArityDefs",
               "moduleName" => "Styx.Api.mark1",
               "severity" => "ERROR"
             }
           ] ==
             body
             |> String.split("\n")
             |> Enum.map(&Jason.decode!/1)
  end
end
