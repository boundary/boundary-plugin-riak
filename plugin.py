from __future__ import (absolute_import, division, print_function, unicode_literals)
import logging
import datetime
import time
import sys
import urllib2
import json

import boundary_plugin

"""
If getting statistics from Riak fails, we will retry up to this number of times before
giving up and aborting the plugin.  Use 0 for unlimited retries.
"""
PLUGIN_RETRY_COUNT = 0
"""
If getting statistics from Riak fails, we will wait this long (in seconds) before retrying.
"""
PLUGIN_RETRY_DELAY = 5


class RiakPlugin(object):
    def __init__(self, boundary_metric_prefix):
        self.boundary_metric_prefix = boundary_metric_prefix
        self.settings = boundary_plugin.parse_params()

    def get_stats(self):
        req = urllib2.urlopen(self.settings.get("stats_url", "http://127.0.0.1:8098/stats"))
        res = req.read()
        req.close()

        data = json.loads(res)
        return data

    def get_stats_with_retries(self, *args, **kwargs):
        """
        Calls the get_stats function, taking into account retry configuration.
        """
        retry_range = xrange(PLUGIN_RETRY_COUNT) if PLUGIN_RETRY_COUNT > 0 else iter(int, 1)
        for _ in retry_range:
            try:
                return self.get_stats(*args, **kwargs)
            except Exception as e:
                logging.error("Error retrieving Riak data: %s" % e)
                time.sleep(PLUGIN_RETRY_DELAY)

        logging.fatal("Max retries exceeded retrieving Riak data")
        raise Exception("Max retries exceeded retrieving Riak data")

    @staticmethod
    def get_metric_list():
        return (
            ('rings_reconciled', 'RIAK_RINGS_RECONCILED', None),
            ('gossip_received', 'RIAK_GOSSIP_RECEIVED', None),
            ('converge_delay_mean', 'RIAK_CONVERGE_DELAY_MEAN', None),
            ('rebalance_delay_mean', 'RIAK_REBALANCE_DELAY_MEAN', None),
            ('riak_kv_vnodes_running', 'RIAK_KV_VNODES_RUNNING', None),
            ('riak_kv_vnodeq_median', 'RIAK_KV_VNODEQ_MEDIAN', None),
            ('riak_kv_vnodeq_total', 'RIAK_KV_VNODEQ_TOTAL', None),
            ('riak_pipe_vnodes_running', 'RIAK_PIPE_VNODES_RUNNING', None),
            ('riak_pipe_vnodeq_median', 'RIAK_PIPE_VNODEQ_MEDIAN', None),
            ('riak_pipe_vnodeq_total', 'RIAK_PIPE_VNODEQ_TOTAL', None),
            ('node_get_fsm_in_rate', 'RIAK_NODE_GET_FSM_IN_RATE', None),
            ('node_get_fsm_out_rate', 'RIAK_NODE_GET_FSM_OUT_RATE', None),
            ('node_put_fsm_in_rate', 'RIAK_NODE_PUT_FSM_IN_RATE', None),
            ('node_put_fsm_out_rate', 'RIAK_NODE_PUT_FSM_OUT_RATE', None),
            ('node_gets', 'RIAK_NODE_GETS', None),
            ('node_puts', 'RIAK_NODE_PUTS', None),
            ('pbc_connects', 'RIAK_PBC_CONNECTS', None),
            ('read_repairs', 'RIAK_READ_REPAIRS', None),
            ('node_get_fsm_time_mean', 'RIAK_NODE_GET_FSM_TIME_MEAN', None),
            ('node_put_fsm_time_mean', 'RIAK_NODE_PUT_FSM_TIME_MEAN', None),
            ('node_get_fsm_siblings_mean', 'RIAK_NODE_GET_FSM_SIBLINGS_MEAN', None),
            ('node_get_fsm_objsize_mean', 'RIAK_NODE_GET_FSM_OBJSIZE_MEAN', None),
            ('memory_total', 'RIAK_MEMORY_TOTAL', None),
            ('pipeline_active', 'RIAK_PIPELINE_ACTIVE', None),
            ('pipeline_create_one', 'RIAK_PIPELINE_CREATE_ONE', None),
            ('riak_search_vnodeq_mean', 'RIAK_SEARCH_VNODEQ_MEAN', None),
            ('riak_search_vnodeq_total', 'RIAK_SEARCH_VNODEQ_TOTAL', None),
            ('riak_search_vnodes_running', 'RIAK_SEARCH_VNODES_RUNNING', None),
            ('consistent_gets', 'RIAK_CONSISTENT_GETS', None),
            ('consistent_get_objsize_mean', 'RIAK_CONSISTENT_GET_OBJSIZE_MEAN', None),
            ('consistent_get_time_mean', 'RIAK_CONSISTENT_GET_TIME_MEAN', None),
            ('consistent_puts', 'RIAK_CONSISTENT_PUTS', None),
            ('consistent_put_objsize_mean', 'RIAK_CONSISTENT_PUT_OBJSIZE_MEAN', None),
            ('consistent_put_time_mean', 'RIAK_CONSISTENT_PUT_TIME_MEAN', None),
        )

    def handle_metrics(self, data):
        for metric_item in self.get_metric_list():
            riak_name, boundary_name, scale = metric_item[:3]
            if not data.has_key(riak_name):
                # If certain Riak features are disabled (e.g. search), their data might
                # not be available - simply skip those metrics.
                continue
            if scale:
                data[riak_name] *= scale
            boundary_plugin.boundary_report_metric(self.boundary_metric_prefix + boundary_name, data[riak_name])

    def main(self):
        logging.basicConfig(level=logging.ERROR, filename=self.settings.get('log_file', None))
        reports_log = self.settings.get('report_log_file', None)
        if reports_log:
            boundary_plugin.log_metrics_to_file(reports_log)
        boundary_plugin.start_keepalive_subprocess()

        while True:
            data = self.get_stats_with_retries()
            self.handle_metrics(data)
            boundary_plugin.sleep_interval()


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '-v':
        logging.basicConfig(level=logging.INFO)

    plugin = RiakPlugin('')
    plugin.main()
