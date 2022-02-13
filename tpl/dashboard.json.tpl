{
  "title": "EMPC lab-platform-eks-base",
  "description": "[lab-platform-eks-base](https://github.com/ThoughtWorks-DPS/lab-platform-eks-base)",
  "widgets": [
    {
      "definition": {
        "title": "API",
        "title_size": "16",
        "title_align": "left",
        "type": "check_status",
        "check": "kube_apiserver_controlplane.up",
        "grouping": "cluster",
        "group": "$cluster",
        "group_by": [
          "eks"
        ],
        "tags": [
          "$cluster"
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 1,
        "height": 1
      }
    },
    {
      "definition": {
        "title": "Nodes",
        "title_size": "16",
        "title_align": "left",
        "type": "check_status",
        "check": "aws.ec2.host_status",
        "grouping": "cluster",
        "group": "$cluster",
        "group_by": [],
        "tags": [
          "$cluster"
        ]
      },
      "layout": {
        "x": 1,
        "y": 0,
        "width": 1,
        "height": 1
      }
    },
    {
      "definition": {
        "title": "Kubelets",
        "title_size": "16",
        "title_align": "left",
        "type": "check_status",
        "check": "kubernetes.kubelet.check",
        "grouping": "cluster",
        "group": "$cluster",
        "group_by": [],
        "tags": [
          "$cluster"
        ]
      },
      "layout": {
        "x": 2,
        "y": 0,
        "width": 1,
        "height": 1
      }
    },
    {
      "definition": {
        "type": "note",
        "content": "Dependencies",
        "background_color": "gray",
        "font_size": "18",
        "text_align": "center",
        "vertical_align": "center",
        "show_tick": false,
        "tick_pos": "50%",
        "tick_edge": "left",
        "has_padding": true
      },
      "layout": {
        "x": 3,
        "y": 0,
        "width": 8,
        "height": 1
      }
    },
    {
      "definition": {
        "title": "Services",
        "title_size": "16",
        "title_align": "left",
        "type": "query_value",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "query": "sum:kubernetes_state.service.count{$cluster}",
                "data_source": "metrics",
                "name": "query1",
                "aggregator": "avg"
              }
            ]
          }
        ],
        "autoscale": true,
        "precision": 0
      },
      "layout": {
        "x": 0,
        "y": 1,
        "width": 1,
        "height": 1
      }
    },
    {
      "definition": {
        "title": "Pods",
        "title_size": "16",
        "title_align": "left",
        "type": "query_value",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "query": "sum:kubernetes_state.pod.count{$cluster}",
                "data_source": "metrics",
                "name": "query1",
                "aggregator": "avg"
              }
            ]
          }
        ],
        "autoscale": true,
        "precision": 0
      },
      "layout": {
        "x": 1,
        "y": 1,
        "width": 1,
        "height": 1
      }
    },
    {
      "definition": {
        "title": "Containers",
        "title_size": "16",
        "title_align": "left",
        "type": "query_value",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "query": "sum:kubernetes_state.container.running{$cluster}",
                "data_source": "metrics",
                "name": "query1",
                "aggregator": "avg"
              }
            ]
          }
        ],
        "autoscale": true,
        "precision": 0
      },
      "layout": {
        "x": 2,
        "y": 1,
        "width": 1,
        "height": 1
      }
    },
    {
      "definition": {
        "type": "note",
        "content": "CURRENT_TABLE",
        "background_color": "yellow",
        "font_size": "14",
        "text_align": "left",
        "vertical_align": "top",
        "show_tick": true,
        "tick_pos": "50%",
        "tick_edge": "left",
        "has_padding": true
      },
      "layout": {
        "x": 3,
        "y": 1,
        "width": 6,
        "height": 3
      }
    },
    {
      "definition": {
        "type": "note",
        "content": "LATEST_TABLE",
        "background_color": "TABLE_COLOR",
        "font_size": "14",
        "text_align": "left",
        "vertical_align": "top",
        "show_tick": true,
        "tick_pos": "50%",
        "tick_edge": "left",
        "has_padding": true
      },
      "layout": {
        "x": 9,
        "y": 1,
        "width": 2,
        "height": 3
      }
    },
    {
      "definition": {
        "title": "Monitor Summary",
        "title_size": "13",
        "title_align": "left",
        "type": "manage_status",
        "summary_type": "monitors",
        "display_format": "countsAndList",
        "color_preference": "text",
        "hide_zero_counts": true,
        "show_last_triggered": false,
        "show_priority": false,
        "query": "tag:pipeline:lab-platform-eks-base",
        "sort": "status,asc",
        "count": 50,
        "start": 0
      },
      "layout": {
        "x": 0,
        "y": 2,
        "width": 3,
        "height": 4
      }
    },
    {
      "definition": {
        "title": "EKS Addon pod restarts",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              },
              {
                "formula": "query2"
              },
              {
                "formula": "query3"
              },
              {
                "formula": "query4"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "sum:kubernetes.containers.restarts{$cluster,kube_daemon_set:aws-node}",
                "data_source": "metrics",
                "name": "query1"
              },
              {
                "query": "sum:kubernetes.containers.restarts{$cluster,kube_daemon_set:kube-proxy}",
                "data_source": "metrics",
                "name": "query2"
              },
              {
                "query": "sum:kubernetes.containers.restarts{$cluster,kube_daemon_set:ebs-csi-node}",
                "data_source": "metrics",
                "name": "query3"
              },
              {
                "query": "sum:kubernetes.containers.restarts{$cluster,kube_deployment:coredns}",
                "data_source": "metrics",
                "name": "query4"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 3,
        "y": 4,
        "width": 8,
        "height": 2
      }
    },
    {
      "definition": {
        "type": "note",
        "content": "Resource Utilization",
        "background_color": "gray",
        "font_size": "18",
        "text_align": "center",
        "vertical_align": "center",
        "show_tick": false,
        "tick_pos": "50%",
        "tick_edge": "left",
        "has_padding": true
      },
      "layout": {
        "x": 0,
        "y": 6,
        "width": 11,
        "height": 1
      }
    },
    {
      "definition": {
        "title": "Most CPU-intensive Pods",
        "title_size": "16",
        "title_align": "left",
        "type": "toplist",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1",
                "limit": {
                  "count": 10,
                  "order": "desc"
                }
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "query": "avg:kubernetes.cpu.usage.total{$cluster} by {pod_name}",
                "data_source": "metrics",
                "name": "query1",
                "aggregator": "avg"
              }
            ]
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 7,
        "width": 3,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Trend: CPU Usage vs Available",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "forecast(query1, 'linear', 1)"
              },
              {
                "formula": "forecast(query2, 'linear', 1)"
              },
              {
                "formula": "forecast(query3, 'linear', 1)"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "sum:kubernetes.cpu.requests{$cluster}",
                "data_source": "metrics",
                "name": "query1"
              },
              {
                "query": "sum:kubernetes.cpu.limits{$cluster}",
                "data_source": "metrics",
                "name": "query2"
              },
              {
                "query": "sum:system.cpu.num_cores{$cluster}",
                "data_source": "metrics",
                "name": "query3"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 3,
        "y": 7,
        "width": 3,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "CPU Usage by Pod",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "avg:kubernetes.cpu.usage.total{$cluster} by {pod_name}",
                "data_source": "metrics",
                "name": "query1"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 6,
        "y": 7,
        "width": 5,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Most Memory-intensive Pods",
        "title_size": "16",
        "title_align": "left",
        "type": "toplist",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1",
                "limit": {
                  "count": 10,
                  "order": "desc"
                }
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "query": "avg:kubernetes.memory.usage{$cluster} by {pod_name}",
                "data_source": "metrics",
                "name": "query1",
                "aggregator": "avg"
              }
            ]
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 9,
        "width": 3,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Trend: MEM Usage vs Available",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "forecast(query1, 'linear', 1)"
              },
              {
                "formula": "forecast(query2, 'linear', 1)"
              },
              {
                "formula": "forecast(query3, 'linear', 1)"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "sum:kubernetes.memory.requests{$cluster}",
                "data_source": "metrics",
                "name": "query1"
              },
              {
                "query": "sum:system.mem.total{$cluster}",
                "data_source": "metrics",
                "name": "query2"
              },
              {
                "query": "sum:kubernetes.memory.limits{$cluster}",
                "data_source": "metrics",
                "name": "query3"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 3,
        "y": 9,
        "width": 3,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Memory Usage by Pod",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "sum:kubernetes.memory.usage{$cluster} by {pod_name}",
                "data_source": "metrics",
                "name": "query1"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 6,
        "y": 9,
        "width": 5,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Most Write-intensive by Pod",
        "title_size": "16",
        "title_align": "left",
        "type": "toplist",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1",
                "limit": {
                  "count": 10,
                  "order": "desc"
                }
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "query": "avg:kubernetes.io.write_bytes{$cluster,$node} by {pod_name}",
                "data_source": "metrics",
                "name": "query1",
                "aggregator": "avg"
              }
            ]
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 11,
        "width": 3,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Disk Reads per Node",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "avg:kubernetes.io.read_bytes{$cluster} by {host}",
                "data_source": "metrics",
                "name": "query1"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 3,
        "y": 11,
        "width": 4,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Disk Write per Node",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query2"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "avg:kubernetes.io.write_bytes{$cluster} by {host}",
                "data_source": "metrics",
                "name": "query2"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 7,
        "y": 11,
        "width": 4,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Node Disk Space",
        "title_size": "16",
        "title_align": "left",
        "type": "query_table",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1",
                "conditional_formats": [
                  {
                    "palette": "white_on_yellow",
                    "comparator": ">",
                    "value": 0.8
                  }
                ],
                "limit": {
                  "count": 500,
                  "order": "desc"
                },
                "cell_display_mode": "bar"
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "query": "avg:system.disk.in_use{$cluster} by {host}",
                "data_source": "metrics",
                "name": "query1",
                "aggregator": "avg"
              }
            ]
          }
        ],
        "has_search_bar": "auto"
      },
      "layout": {
        "x": 0,
        "y": 13,
        "width": 3,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Network Errors by Pod",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              },
              {
                "formula": "query2"
              },
              {
                "formula": "query3"
              },
              {
                "formula": "query4"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "avg:kubernetes.network.rx_errors{$cluster} by {pod_name}",
                "data_source": "metrics",
                "name": "query1"
              },
              {
                "query": "avg:kubernetes.network.tx_errors{$cluster} by {pod_name}",
                "data_source": "metrics",
                "name": "query2"
              },
              {
                "query": "avg:kubernetes.network.rx_dropped{$cluster} by {pod_name}",
                "data_source": "metrics",
                "name": "query3"
              },
              {
                "query": "avg:kubernetes.network.tx_dropped{$cluster} by {pod_name}",
                "data_source": "metrics",
                "name": "query4"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 3,
        "y": 13,
        "width": 4,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Network Traffic by Node",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              },
              {
                "formula": "query2"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "query": "sum:kubernetes.network.rx_bytes{$cluster} by {host}",
                "data_source": "metrics",
                "name": "query1"
              },
              {
                "query": "sum:kubernetes.network.tx_bytes{$cluster} by {host}",
                "data_source": "metrics",
                "name": "query2"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ]
      },
      "layout": {
        "x": 7,
        "y": 13,
        "width": 4,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "Pods running by namespace",
        "title_size": "16",
        "title_align": "left",
        "type": "toplist",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1",
                "limit": {
                  "count": 100,
                  "order": "desc"
                }
              }
            ],
            "conditional_formats": [
              {
                "comparator": ">",
                "palette": "white_on_red",
                "value": 200
              },
              {
                "comparator": ">",
                "palette": "white_on_yellow",
                "value": 150
              },
              {
                "comparator": "<=",
                "palette": "white_on_green",
                "value": 150
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "query": "sum:kubernetes.pods.running{$cluster} by {kube_namespace}",
                "data_source": "metrics",
                "name": "query1",
                "aggregator": "max"
              }
            ]
          }
        ],
        "custom_links": []
      },
      "layout": {
        "x": 0,
        "y": 15,
        "width": 3,
        "height": 6
      }
    },
    {
      "definition": {
        "title": "CoreDNS Cache Hit %",
        "title_size": "16",
        "title_align": "left",
        "show_legend": false,
        "time": {},
        "type": "heatmap",
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ],
        "requests": [
          {
            "q": "avg:coredns.cache_hits_count{$cluster,$node} by {host}.as_count()*100/(avg:coredns.cache_hits_count{$cluster,$node} by {host}.as_count()+avg:coredns.cache_misses_count{$cluster,$node} by {host}.as_count())",
            "style": {
              "palette": "purple"
            }
          }
        ]
      },
      "layout": {
        "x": 3,
        "y": 15,
        "width": 8,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "CoreDNS Average Upstream Request Latency",
        "title_size": "16",
        "title_align": "left",
        "show_legend": false,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "alias": "Upstream Request Latency",
                "formula": "query1 / query2"
              }
            ],
            "response_format": "timeseries",
            "on_right_yaxis": false,
            "queries": [
              {
                "query": "sum:coredns.forward_request_duration.seconds.sum{$cluster,$node}",
                "data_source": "metrics",
                "name": "query1"
              },
              {
                "query": "sum:coredns.forward_request_duration.seconds.count{$cluster,$node}",
                "data_source": "metrics",
                "name": "query2"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        },
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ],
        "markers": []
      },
      "layout": {
        "x": 3,
        "y": 17,
        "width": 4,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "CoreDNS Average Request Latency",
        "title_size": "16",
        "title_align": "left",
        "show_legend": false,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "alias": "Request Latency",
                "formula": "query1 / query2"
              }
            ],
            "response_format": "timeseries",
            "on_right_yaxis": false,
            "queries": [
              {
                "query": "sum:coredns.request_duration.seconds.sum{$cluster,$node}",
                "data_source": "metrics",
                "name": "query1"
              },
              {
                "query": "sum:coredns.request_duration.seconds.count{$cluster,$node}",
                "data_source": "metrics",
                "name": "query2"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        },
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ],
        "markers": []
      },
      "layout": {
        "x": 7,
        "y": 17,
        "width": 4,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "CoreDNS Upstream Rcode Errors",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "horizontal",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "on_right_yaxis": false,
            "queries": [
              {
                "query": "avg:coredns.forward_response_rcode_count{$cluster,$node} by {rcode}.as_count()",
                "data_source": "metrics",
                "name": "query1"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        },
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ],
        "markers": []
      },
      "layout": {
        "x": 3,
        "y": 19,
        "width": 4,
        "height": 2
      }
    },
    {
      "definition": {
        "title": "CoreDNS Rcode Errors",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "horizontal",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "on_right_yaxis": false,
            "queries": [
              {
                "query": "avg:coredns.response_code_count{$cluster,$node} by {rcode}.as_count()",
                "data_source": "metrics",
                "name": "query1"
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        },
        "events": [
          {
            "q": "tags:cluster:$cluster, deployment:lab*"
          }
        ],
        "markers": []
      },
      "layout": {
        "x": 7,
        "y": 19,
        "width": 4,
        "height": 2
      }
    }
  ],
  "template_variables": [
    {
      "name": "cluster",
      "default": "sandbox",
      "prefix": "cluster",
      "available_values": []
    },
    {
      "name": "node",
      "default": "*",
      "prefix": "node",
      "available_values": []
    }
  ],
  "layout_type": "ordered",
  "is_read_only": false,
  "notify_list": [],
  "reflow_type": "fixed",
  "id": "u7z-5p7-cfs"
}