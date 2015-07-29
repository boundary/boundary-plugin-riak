-- Copyright 2015 Boundary, Inc.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local framework = require('framework')
local Plugin = framework.Plugin
local WebRequestDataSource = framework.WebRequestDataSource
local parseJson = framework.util.parseJson
local url = require('url')
local isHttpSuccess = framework.util.isHttpSuccess
local notEmpty = framework.string.notEmpty

local params = framework.params
params.url = notEmpty(params.url, 'http://127.0.0.1:8098/stats')

local options = url.parse(params.url)

local ds = WebRequestDataSource:new(options)
local plugin = Plugin:new(params, ds)
function plugin:onParseValues(data, extra)
  if not isHttpSuccess(extra.status_code) then
    self:emitEvent('error', ('Http request returned status code %s instead of OK. Please verify Riak stats endpoint configuration.'):format(extra.status_code))
    return
  end
  local success, parsed = parseJson(data)
  if not success then
    self:emitEvent('error', 'Can not parse metrics. Please verify Riak stats endpoint configuration.')
    return 
  end
  local result = {
    ['RIAK_RINGS_RECONCILED'] = parsed.rings_reconciled,
    ['RIAK_GOSSIP_RECEIVED'] = parsed.gossip_received,
    ['RIAK_CONVERGE_DELAY_MEAN'] = parsed.converge_delay_mean,
    ['RIAK_REBALANCE_DELAY_MEAN'] = parsed.rebalance_delay_mean,
    ['RIAK_KV_VNODES_RUNNING' ] = parsed.riak_kv_vnodes_running,
    ['RIAK_KV_VNODEQ_MEDIAN' ] = parsed.riak_kv_vnodeq_median,
    ['RIAK_KV_VNODEQ_TOTAL' ] = parsed.riak_kv_vnodeq_total,
    ['RIAK_PIPE_VNODES_RUNNING' ] = parsed.riak_pipe_vnodes_running,
    ['RIAK_PIPE_VNODEQ_MEDIAN' ] = parsed.riak_pipe_vnodeq_median,
    ['RIAK_PIPE_VNODEQ_TOTAL' ] = parsed.riak_pipe_vnodeq_total,
    ['RIAK_NODE_GET_FSM_IN_RATE' ] = parsed.node_get_fsm_in_rate,
    ['RIAK_NODE_GET_FSM_OUT_RATE' ] = parsed.node_get_fsm_out_rate,
    ['RIAK_NODE_PUT_FSM_IN_RATE' ] = parsed.node_put_fsm_in_rate,
    ['RIAK_NODE_PUT_FSM_OUT_RATE' ] = parsed.node_put_fsm_out_rate,
    ['RIAK_NODE_GETS' ] = parsed.node_gets,
    ['RIAK_NODE_PUTS' ] = parsed.node_puts,
    ['RIAK_PBC_CONNECTS' ] = parsed.pbc_connects,
    ['RIAK_READ_REPAIRS' ] = parsed.read_repairs,
    ['RIAK_NODE_GET_FSM_TIME_MEAN' ] = parsed.node_get_fsm_time_mean,
    ['RIAK_NODE_PUT_FSM_TIME_MEAN' ] = parsed.node_put_fsm_time_mean,
    ['RIAK_NODE_GET_FSM_SIBLINGS_MEAN' ] = parsed.node_get_fsm_siblings_mean,
    ['RIAK_NODE_GET_FSM_OBJSIZE_MEAN' ] = parsed.node_get_fsm_objsize_mean,
    ['RIAK_MEMORY_TOTAL' ] = parsed.memory_total,
    ['RIAK_PIPELINE_ACTIVE' ] = parsed.pipeline_active,
    ['RIAK_PIPELINE_CREATE_ONE' ] = parsed.pipeline_create_one,
    ['RIAK_SEARCH_VNODEQ_MEAN' ] = parsed.riak_search_vnodeq_mean,
    ['RIAK_SEARCH_VNODEQ_TOTAL' ] = parsed.riak_search_vnodeq_total,
    ['RIAK_SEARCH_VNODES_RUNNING' ] = parsed.riak_search_vnodes_running,
    ['RIAK_CONSISTENT_GETS' ] = parsed.consistent_gets,
    ['RIAK_CONSISTENT_GET_OBJSIZE_MEAN' ] = parsed.consistent_get_objsize_mean,
    ['RIAK_CONSISTENT_GET_TIME_MEAN' ] = parsed.consistent_get_time_mean,
    ['RIAK_CONSISTENT_PUTS' ] = parsed.consistent_puts,
    ['RIAK_CONSISTENT_PUT_OBJSIZE_MEAN' ] = parsed.consistent_put_objsize_mean,
    ['RIAK_CONSISTENT_PUT_TIME_MEAN' ] = parsed.consistent_put_time_mean
  }

  return result 
end

plugin:run()
