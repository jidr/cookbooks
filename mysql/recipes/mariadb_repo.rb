#
# Cookbook Name:: mysql
# Recipe:: mariadb_repo
#
# Copyright 2008-2009, Opscode, Inc.
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


case node['platform']
when "ubuntu"
  include_recipe "apt"
  apt_repository "mariadb_ubuntu" do
    uri node['mysql']['mariadb_ubuntu']['apt_uri']
    distribution node['lsb']['codename']
    components [ "main" ]
    keyserver node['mysql']['mariadb_ubuntu']['apt_keyserver']
    key node['mysql']['mariadb_ubuntu']['apt_key_id']
    action :add
  end
when "debian"
  include_recipe "apt"
  apt_repository "mariadb_debian" do
    uri node['mysql']['mariadb_debian']['apt_uri']
    distribution node['lsb']['codename']
    components [ "main" ]
    keyserver node['mysql']['mariadb_debian']['apt_keyserver']
    key node['mysql']['mariadb_debian']['apt_key_id']
    action :add
  end
when "centos", "amazon", "redhat"
  include_recipe "yum"
  yum_key "RPM-GPG-KEY-MariaDB" do
    url "https://yum.mariadb.org/RPM-GPG-KEY-MariaDB"
    action :add
  end
  arch = node['kernel']['machine']
  arch = "i386" unless arch == "amd64"
  pversion = node['platform_version']
  yum_repository "mariadb" do
    repo_name "MariaDB"
    description "MariaDB Repo"
    url "http://yum.mariadb.org/5.5/centos#{pversion}-amd64 /os/#{arch}/"
    key "RPM-GPG-KEY-MariaDB"
    action :add
  end
end
