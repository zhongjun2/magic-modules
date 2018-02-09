<% if false # the license inside this if block assertains to this file -%>
# Copyright 2017 Google Inc.
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
<% end -%>
<% unless name == "README.md" -%>
<%= compile 'templates/license.erb' -%>

<%= compile 'templates/autogen_notice.erb' -%>

<%= compile 'templates/puppet/examples~credential.pp.erb' -%>

gpubsub_topic { <%= example_resource_name('conversation-1') -%>:
  ensure     => present,
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

<% end # name == README.md -%>
gpubsub_subscription { <%= example_resource_name('subscription-1') -%>:
  ensure               => present,
  topic                => <%= example_resource_name('conversation-1') -%>,
  push_config          => {
    push_endpoint => 'https://myapp.graphite.cloudnativeapp.com/webhook/sub1',
  },
  ack_deadline_seconds => 300,
  project              => 'google.com:graphite-playground',
  credential           => 'mycred',
}