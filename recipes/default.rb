#
# Cookbook:: netconfig
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'netconfig::_netconfig'
include_recipe 'netconfig::_supervisor'
include_recipe 'netconfig::_nginx'
