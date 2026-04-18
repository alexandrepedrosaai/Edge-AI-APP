import Config

config :libcluster,
  topologies: [
    edge_ai_cluster: [
      strategy: Cluster.Strategy.Gossip,
      config: [
        port: 45892
      ]
    ]
  ]
