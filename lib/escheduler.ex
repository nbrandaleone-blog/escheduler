defmodule Escheduler do
  #use Application
  @moduledoc "Kubernetes scheduler that binds pods to random nodes."
  @name "escheduler"

  def main(_args \\ []) do
    unscheduled_pods()
    |> schedule()
  end

  def unscheduled_pods() do
    is_managed_by_us = &(get_in(&1, ["spec", "schedulerName"]) == @name)

    resp = HTTPoison.get! "http://127.0.0.1:8001/api/v1/pods?fieldSelector=spec.nodeName="
    resp.body
    |> Poison.decode!
    |> get_in(["items"])
    |> Enum.filter(is_managed_by_us)
    |> Enum.map(&(get_in(&1, ["metadata", "name"])))
#	|> IO.inspect
  end

  def nodes() do
    resp = HTTPoison.get! "http://127.0.0.1:8001/api/v1/nodes"
    resp.body
    |> Poison.decode!
    |> get_in(["items"])
    |> Enum.map(&(get_in(&1, ["metadata", "name"])))
#	|> IO.inspect
  end

  def bind(pod_name, node_name) do
    url = "http://127.0.0.1:8001/api/v1/namespaces/default/pods/#{pod_name}/binding"
    body = Poison.encode!(%{
      apiVersion: "v1",
      kind: "Binding",
      metadata: %{
        name: pod_name
      },
      target: %{
        apiVersion: "v1",
        kind: "Node",
        name: node_name
      }
    })
    headers = [{"Content-Type", "application/json"}]
	# headers must be strings or httpoison/hackney complains
	options = [follow_redirect: true]

    _resp = HTTPoison.post!(url, body, headers, options)
	# IO.inspect _resp
    IO.puts "#{pod_name} pod scheduled in #{node_name}"
  end

  def schedule(pods) do
    pods
    |> Enum.each(&(bind(&1, Enum.random(nodes()))))
  end
end
