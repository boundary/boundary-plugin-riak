Boundary Riak Plugin
====================

The Boundary Riak plugin collects information on Riak clusters.

The plugin requires the Riak [stats endpoint](http://docs.basho.com/riak/latest/dev/references/http/status/) to be enabled and accessible from the machine running the relay.

The plugin requires Python 2.6 or later.

## Metrics

The information collected is a subset of the [stats endpoint data](http://docs.basho.com/riak/latest/dev/references/http/status/), which also includes some data from the [riak-admin status](http://docs.basho.com/riak/latest/ops/running/nodes/inspecting/) command.

## Adding the Riak Plugin to Premium Boundary

1. Login into Boundary Premium
2. Display the settings dialog by clicking on the _settings icon_: ![](src/main/resources/settings_icon.png)
3. Click on the _Plugins_ in the settings dialog.
4. Locate the _riak_ plugin item and click on the _Install_ button.
5. A confirmation dialog is displayed indicating the plugin was installed successfully, along with the metrics and the dashboards.
6. Click on the _OK_ button to dismiss the dialog.

## Removing the Riak Plugin from Premium Boundary

1. Login into Boundary Premium
2. Display the settings dialog by clicking on the _settings icon_: ![](src/main/resources/settings_icon.png)
3. Click on the _Plugins_ in the settings dialog which lists the installed plugins.
4. Locate the _riak_ plugin and click on the item, which then displays the uninstall dialog.
5. Click on the _Uninstall_ button which displays a confirmation dialog along with the details on what metrics and dashboards will be removed.
6. Click on the _Uninstall_ button to perfom the actual uninstall and then click on the _Close_ button to dismiss the dialog.

## Configuration

Once the Riak plugin is installed, metric collection requires that a _relay_ is installed on the target system. Instructions on how to install a relay for Linux/Unix can found [here](http://premium-documentation.boundary.com/relays), and for Windows [here](http://premium-support.boundary.com/customer/portal/articles/1656465-installing-relay-on-windows).

Before the plugin will collect metrics, you must provide it with the URL used to access the Riak stats endpoint.  By default, this is "http://127.0.0.1:8098/stats", but it could be different if you have configured a different port.

General operations for plugins are described in [this article](http://premium-support.boundary.com/customer/portal/articles/1635550-plugins---how-to).
