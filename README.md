Boundary Riak Plugin
--------------------

The Boundary Riak plugin collects information on Riak clusters.

### Platforms
- Linux
- OS X
- Smart OS

### Prerequisites
- Python 2.6 or later
- Requires Riak [stats endpoint](http://docs.basho.com/riak/latest/dev/references/http/status/) to be enabled and accessible from the machine running the plugin.

### Plugin Setup

None


### Plugin Configuration Fields

Before the plugin will collect metrics, you must provide it with the URL used to access the Riak stats endpoint.  By default, this is "http://127.0.0.1:8098/stats", but it could be different if you have configured a different port.

|Field Name    |Description                         |
|:-------------|:-----------------------------------|
|Riak Stats URL|The URL to Riak's stats API endpoint|

## Metrics Collected

The information collected is a subset of the [stats endpoint data](http://docs.basho.com/riak/latest/dev/references/http/status/), which also includes some data from the [riak-admin status](http://docs.basho.com/riak/latest/ops/running/nodes/inspecting/) command.


