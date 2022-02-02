defmodule CredoJenkinsTest do
  use ExUnit.Case

  @moduledoc false
  describe "run/2" do
    test "reads and outputs a file" do
      CredoJenkins.run("test/fixtures/credo_ok.json", ".tmp/credo.report")
      assert {:ok, "// end"} = File.read(".tmp/credo.report")
    end

    test "raises when given an empty file" do
      assert_raise Jason.DecodeError, fn ->
        CredoJenkins.run("test/fixtures/credo_empty.json", ".tmp/credo.report")
      end
    end

    test "raises when given an malformed file" do
      assert_raise Jason.DecodeError, fn ->
        CredoJenkins.run("test/fixtures/credo_malformed.json", ".tmp/credo.report")
      end
    end

    test "reads and outputs a file with errors" do
      CredoJenkins.run("test/fixtures/credo_errors.json", ".tmp/credo.report")
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

  describe "transform/1" do
    test "returns an empty string for an empty report" do
      assert "" == CredoJenkins.transform([])
    end

    test "raises when not given an list" do
      assert_raise Protocol.UndefinedError, fn -> CredoJenkins.transform(nil) end
    end

    test "returns an a transformed item" do
      assert CredoJenkins.transform([
               %{
                 "category" => "readability",
                 "check" => "Credo.Check.Readability.ParenthesesOnZeroArityDefs",
                 "column" => 1,
                 "column_end" => 12,
                 "filename" => "lib/styx/api.ex",
                 "line_no" => 38,
                 "message" => "Do not use parentheses when...",
                 "priority" => -8,
                 "scope" => "Styx.Api.mark",
                 "trigger" => "IO.inspect/1"
               }
             ]) ==
               "{\"category\":\"readability\",\"columnEnd\":12,\"columnStart\":1,\"description\":\"Do not use parentheses when...\",\"fileName\":\"lib/styx/api.ex\",\"lineEnd\":38,\"lineStart\":38,\"message\":\"Credo.Check.Readability.ParenthesesOnZeroArityDefs\",\"moduleName\":\"Styx.Api.mark\",\"origin\":\"IO.inspect/1\",\"severity\":\"ERROR\"}"
    end
  end
end
