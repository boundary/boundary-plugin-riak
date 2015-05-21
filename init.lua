--
-- [boundary.com] Riak Lua Plugin
-- [author] Valeriu Paloş <me@vpalos.com>
--

--
-- Imports.
--
local dns   = require('dns')
local fs    = require('fs')
local io    = require('io')
local json  = require('json')
local http  = require('http')
local os    = require('os')
local timer = require('timer')
local url   = require('url')
local boundary   = require('boundary')

--
-- Initialize.
--
local _buckets          = {}
local _parameters       = boundary.param

local _statisticsUri    = _parameters.statisticsUri or 'http://127.0.0.1:8098/stats'
local _pollRetryCount   = tonumber(_parameters.pollRetryCount) or    5
local _pollRetryDelay   = tonumber(_parameters.pollRetryDelay) or 3000
local _pollInterval     = tonumber(_parameters.pollInterval)   or 5000

--
-- Metrics source.
--
local _source =
  (type(_parameters.source) == 'string' and _parameters.source:gsub('%s+', '') ~= '' and _parameters.source) or
   io.popen("uname -n"):read('*line')

--
-- Get a JSON data set from the server.
--
function retrieve(callback)
  local _pollRetryRemaining = _pollRetryCount

  local options = url.parse(_statisticsUri)
  options.headers = {
    ['Accept'] = 'application/json'
  }

  function handler(response)
    if (response.status_code ~= 200) then
      return retry("Unexpected status code " .. response.status_code .. ", should be 200!")
    end

    local data = {}
    response:on('data', function(chunk)
      table.insert(data, chunk)
    end)
    response:on('end', function()
      local success, json = pcall(json.parse, table.concat(data))

      if success then
        callback(nil, json)
      else
        callback("Unable to parse incoming data as a valid JSON value!")
      end

      response:destroy()
    end)

    response:once('error', retry)
  end

  function retry(result)
    if _pollRetryRemaining == 0 then
      return callback(result)
    elseif _pollRetryRemaining > 0 then
      _pollRetryRemaining = _pollRetryRemaining - 1
    end
    timer.setTimeout(_pollRetryDelay, perform)
  end

  function perform()
    local request = http.request(options, handler)
    request:once('error', retry)
    request:done()
  end

  perform()
end

--
-- Schedule poll.
--
function schedule()
  timer.setTimeout(_pollInterval, poll)
end

--
-- Print a metric.
--
function metric(stamp, id, value)
  print(string.format('%s %s %s %d', id, value, _source, stamp))
end

--
-- Compile and print metrics from given data.
--
function produce(stamp, data)

  local metrics = {
    ['rings_reconciled' ] =             'RIAK_RINGS_RECONCILED',
    ['gossip_received' ] =              'RIAK_GOSSIP_RECEIVED',
    ['converge_delay_mean' ] =          'RIAK_CONVERGE_DELAY_MEAN',
    ['rebalance_delay_mean' ] =         'RIAK_REBALANCE_DELAY_MEAN',
    ['riak_kv_vnodes_running' ] =       'RIAK_KV_VNODES_RUNNING',
    ['riak_kv_vnodeq_median' ] =        'RIAK_KV_VNODEQ_MEDIAN',
    ['riak_kv_vnodeq_total' ] =         'RIAK_KV_VNODEQ_TOTAL',
    ['riak_pipe_vnodes_running' ] =     'RIAK_PIPE_VNODES_RUNNING',
    ['riak_pipe_vnodeq_median' ] =      'RIAK_PIPE_VNODEQ_MEDIAN',
    ['riak_pipe_vnodeq_total' ] =       'RIAK_PIPE_VNODEQ_TOTAL',
    ['node_get_fsm_in_rate' ] =         'RIAK_NODE_GET_FSM_IN_RATE',
    ['node_get_fsm_out_rate' ] =        'RIAK_NODE_GET_FSM_OUT_RATE',
    ['node_put_fsm_in_rate' ] =         'RIAK_NODE_PUT_FSM_IN_RATE',
    ['node_put_fsm_out_rate' ] =        'RIAK_NODE_PUT_FSM_OUT_RATE',
    ['node_gets' ] =                    'RIAK_NODE_GETS',
    ['node_puts' ] =                    'RIAK_NODE_PUTS',
    ['pbc_connects' ] =                 'RIAK_PBC_CONNECTS',
    ['read_repairs' ] =                 'RIAK_READ_REPAIRS',
    ['node_get_fsm_time_mean' ] =       'RIAK_NODE_GET_FSM_TIME_MEAN',
    ['node_put_fsm_time_mean' ] =       'RIAK_NODE_PUT_FSM_TIME_MEAN',
    ['node_get_fsm_siblings_mean' ] =   'RIAK_NODE_GET_FSM_SIBLINGS_MEAN',
    ['node_get_fsm_objsize_mean' ] =    'RIAK_NODE_GET_FSM_OBJSIZE_MEAN',
    ['memory_total' ] =                 'RIAK_MEMORY_TOTAL',
    ['pipeline_active' ] =              'RIAK_PIPELINE_ACTIVE',
    ['pipeline_create_one' ] =          'RIAK_PIPELINE_CREATE_ONE',
    ['riak_search_vnodeq_mean' ] =      'RIAK_SEARCH_VNODEQ_MEAN',
    ['riak_search_vnodeq_total' ] =     'RIAK_SEARCH_VNODEQ_TOTAL',
    ['riak_search_vnodes_running' ] =   'RIAK_SEARCH_VNODES_RUNNING',
    ['consistent_gets' ] =              'RIAK_CONSISTENT_GETS',
    ['consistent_get_objsize_mean' ] =  'RIAK_CONSISTENT_GET_OBJSIZE_MEAN',
    ['consistent_get_time_mean' ] =     'RIAK_CONSISTENT_GET_TIME_MEAN',
    ['consistent_puts' ] =              'RIAK_CONSISTENT_PUTS',
    ['consistent_put_objsize_mean' ] =  'RIAK_CONSISTENT_PUT_OBJSIZE_MEAN',
    ['consistent_put_time_mean' ] =     'RIAK_CONSISTENT_PUT_TIME_MEAN'
  }

  for tag, label in pairs(metrics) do
    local value = data[tag]
    if value then
      metric(stamp, label, value)
    end
  end

  schedule()
end

--
-- Start producing metrics.
--
function poll()
  retrieve(function(failure, data)
    if failure then
      schedule()
    else
      produce(os.time(), data)
    end
  end)
end

--
-- Trigger collection.
--
poll()
