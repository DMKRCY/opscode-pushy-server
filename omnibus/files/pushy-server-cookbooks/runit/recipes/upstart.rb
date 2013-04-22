#
# Cookbook Name:: runit
# Recipe:: default
#
# Copyright 2008-2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Ensure the previous named iteration of the system job is nuked
execute "initctl stop opscode-pushy-runsvdir" do
  only_if "initctl status opscode-pushy-runsvdir | grep start"
  retries 30
end
file "/etc/init/opscode-pushy-runsvdir.conf" do
  action :delete
end

cookbook_file "/etc/init/opscode-push-jobs-runsvdir.conf" do
  owner "root"
  group "root"
  mode "0644"
  source "opscode-push-jobs-runsvdir.conf"
end

# Keep on trying till the job is found :(
execute "initctl status opscode-push-jobs-runsvdir" do
  retries 30
end

# If we are stop/waiting, start
#
# Why, upstart, aren't you idempotent? :(
execute "initctl start opscode-push-jobs-runsvdir" do
  only_if "initctl status opscode-push-jobs-runsvdir | grep stop"
  retries 30
end
