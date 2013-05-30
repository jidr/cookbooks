#
# Cookbook Name:: mysql
# Recipe:: slave
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

# Make with the CHANGE MASTER TO

master_hostname = File.open('/tmp/master-host', 'rb') { |file| file.read }

print master_hostname

execute "mysql_configure_slave" do
   command "mysql -uroot #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" -e \"CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='#{node['mysql']['server_repl_password']}', MASTER_LOG_FILE='mysqld-bin.000001', MASTER_LOG_POS=4, MASTER_HOST='#{master_hostname}'\""
end

execute "mysql_start_slave" do
  command "mysql -uroot #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" -e \"SLAVE START\""
end
