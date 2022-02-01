# CredoJenkins

**TODO: Add description**

## Local Development
## Running Docker Locally

You can run the whole environment in a docker container.
  - **Pro Tip:** You can use VSCode's "Attach to a Running Container" feature, to develop from within the container.

Usage example:
```bash
# Build and run via
./scripts/run-docker.sh
docker exec -ti credo_jenkins sh

mix test
mix credo --strict
```

# Releases
We tag our releases with semver in mind.
```bash
git tag -a 0.1.0 -m "version 0.1.0"
git push origin --tags
```

Since it is not [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `credo_jenkins` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:credo_jenkins,
       git: "https://github.com/vitalbeats/credo_jenkins.git",
       tag: "0.1.0",
       only: [:dev, :test],
       runtime: false}
  ]
end
```