Boundary Riak Plugin
--------------------

The Boundary Riak plugin collects information on Riak clusters.

### Prerequisites

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |         |    v    |  v   |

#### For Boundary Meter V4.0
(to update/download - curl -fsS -d '{"token":"api.<Your API Key Here>"}' -H 'Content-Type: application/json' https://meter.boundary.com/setup_meter > setup_meter.sh && chmod +x setup_meter.sh && ./setup_meter.sh)

|  Runtime | node.js | Python | Java |
|:---------|:-------:|:------:|:----:|
| Required |         |        |      |

#### For Boundary Meter less than V4.0

|  Runtime | node.js | Python | Java |
|:---------|:-------:|:------:|:----:|
| Required |         |    +   |      |

- Python 2.6 or later
- [How to install Python?](https://help.boundary.com/hc/articles/202270132)
- Requires Riak [stats endpoint](http://docs.basho.com/riak/latest/dev/references/http/status/) to be enabled and accessible from the machine running the plugin.

### Plugin Setup

None


### Plugin Configuration Fields

#### For All Versions

Before the plugin will collect metrics, you must provide it with the URL used to access the Riak stats endpoint.  By default, this is "http://127.0.0.1:8098/stats", but it could be different if you have configured a different port.

|Field Name    |Description                         |
|:-------------|:-----------------------------------|
|Riak Stats URL|The URL to Riak's stats API endpoint|

## Metrics Collected

#### For All Versions

The information collected is a subset of the [stats endpoint data](http://docs.basho.com/riak/latest/dev/references/http/status/), which also includes some data from the [riak-admin status](http://docs.basho.com/riak/latest/ops/running/nodes/inspecting/) command.


