Boundary Riak Plugin
--------------------

The Boundary Riak plugin collects information on Riak clusters.

### Prerequisites

#### Supported OS

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |         |    v    |  v   |

#### Requires Riak [stats endpoint](http://docs.basho.com/riak/latest/dev/references/http/status/) to be enabled and accessible from the machine running the plugin.

#### Boundary Meter Versions V4.0 or later

- To install new meter go to Settings->Installation or [see instructons|https://help.boundary.com/hc/en-us/sections/200634331-Installation]. 
- To upgrade the meter to the latest version - [see instructons|https://help.boundary.com/hc/en-us/articles/201573102-Upgrading-the-Boundary-Meter].

#### For Boundary Meter less than V4.0

|  Runtime | node.js | Python | Java |
|:---------|:-------:|:------:|:----:|
| Required |         |    +   |      |

- Python 2.6 or later
- [How to install Python?](https://help.boundary.com/hc/articles/202270132)

### Plugin Setup

Before the plugin will collect metrics, you must provide it with the URL used to access the Riak stats endpoint.  By default, this is "http://127.0.0.1:8098/stats", but it could be different if you have configured a different port.


### Plugin Configuration Fields

#### For All Versions


|Field Name    |Description                         |
|:-------------|:-----------------------------------|
|Riak Stats URL|The URL to Riak's stats API endpoint|

### Metrics Collected

#### For All Versions

|Field Name                      |Description                                                                                                                               |
|:-------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------|
|RIAK_CONSISTENT_GET_OBJSIZE_MEAN|Mean object size for strongly consistent GETs on this node in the last minute                                                             |
|RIAK_CONSISTENT_GET_TIME_MEAN   |Mean time between reception of client GETs to strongly consistent keys and subsequent response                                            |
|RIAK_CONSISTENT_GETS            |Number of strongly consistent GETs coordinated by this node in the last minute                                                            |
|RIAK_CONSISTENT_PUT_OBJSIZE_MEAN|Mean object size for strongly consistent PUTs on this node in the last minute                                                             |
|RIAK_CONSISTENT_PUT_TIME_MEAN   |Mean time between reception of client PUTs to strongly consistent keys and subsequent response                                            |
|RIAK_CONSISTENT_PUTS            |Number of strongly consistent PUTs coordinated by this node in the last minute                                                            |
|RIAK_CONVERGE_DELAY_MEAN        |Mean time in milliseconds describing time taken for the ring to converge after ring changes                                               |
|RIAK_GOSSIP_RECEIVED            |Number of gossip messages received in the last minute                                                                                     |
|RIAK_KV_VNODEQ_MEDIAN           |Median queue size of all local Riak KV virtual nodes in the last minute                                                                   |
|RIAK_KV_VNODEQ_TOTAL            |Total queue size of all local Riak KV virtual nodes in the last minute                                                                    |
|RIAK_KV_VNODES_RUNNING          |Number of local Riak KV virtual nodes running                                                                                             |
|RIAK_MEMORY_TOTAL               |Total allocated memory (sum of processes and system)                                                                                      |
|RIAK_NODE_GET_FSM_IN_RATE       |Average number of GET FSMs enqueued by Sidejob                                                                                            |
|RIAK_NODE_GET_FSM_OBJSIZE_MEAN  |Mean object size encountered by this node within the last minute                                                                          |
|RIAK_NODE_GET_FSM_OUT_RATE      |Average number of GET FSMs dequeued by Sidejob                                                                                            |
|RIAK_NODE_GET_FSM_SIBLINGS_MEAN |Mean number of siblings encountered during all GET operations by this node within the last minute                                         |
|RIAK_NODE_GET_FSM_TIME_MEAN     |Mean time between reception of client GET request and subsequent response to client                                                       |
|RIAK_NODE_GETS                  |Number of GETs coordinated by this node, including GETs to non-local vnodes in the last minute                                            |
|RIAK_NODE_PUT_FSM_IN_RATE       |Average number of PUT FSMs enqueued by Sidejob                                                                                            |
|RIAK_NODE_PUT_FSM_OUT_RATE      |Average number of PUT FSMs dequeued by Sidejob                                                                                            |
|RIAK_NODE_PUT_FSM_TIME_MEAN     |Mean time between reception of client PUT request and subsequent response to client                                                       |
|RIAK_NODE_PUTS                  |Number of PUTs coordinated by this node, where a PUT is sent to a local vnode in the last minute                                          |
|RIAK_PBC_CONNECTS               |Number of Protocol Buffers connections made in the last minute                                                                            |
|RIAK_PIPE_VNODEQ_MEDIAN         |Median queue size of local Riak Pipe virtual nodes in the last minute                                                                     |
|RIAK_PIPE_VNODEQ_TOTAL          |Total queue size of all local Riak Pipe virtual nodes in the last minute                                                                  |
|RIAK_PIPE_VNODES_RUNNING        |Number of local Riak Pipe virtual nodes running                                                                                           |
|RIAK_PIPELINE_ACTIVE            |The number of pipelines active in the last 60 seconds                                                                                     |
|RIAK_PIPELINE_CREATE_ONE        |The number of pipelines created in the last 60 seconds                                                                                    |
|RIAK_READ_REPAIRS               |Number of read repair operations this node has coordinated in the last minute                                                             |
|RIAK_REBALANCE_DELAY_MEAN       |Mean time in milliseconds describing time taken for the ring to converge after ring changes                                               |
|RIAK_RINGS_RECONCILED           |Number of ring reconciliation operations in the last minute                                                                               |
|RIAK_SEARCH_VNODEQ_MEAN         |Mean number of unprocessed messages all vnode message queues in the Riak Search subsystem have received on this node in the last minute   |
|RIAK_SEARCH_VNODEQ_TOTAL        |Total number of unprocessed messages all vnode message queues in the Riak Search subsystem have received on this node since it was started|
|RIAK_SEARCH_VNODES_RUNNING      |Total number of vnodes currently running in the Riak Search subsystem                                                                     |

### References

The information collected is a subset of the [stats endpoint data](http://docs.basho.com/riak/latest/dev/references/http/status/), which also includes some data from the [riak-admin status](http://docs.basho.com/riak/latest/ops/running/nodes/inspecting/) command.


