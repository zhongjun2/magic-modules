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

require 'api/object'

module Api
  # Represents an asynchronous operation definition
  class Async < Api::Object
    attr_reader :operation
    attr_reader :status_check
    attr_reader :timeout
    attr_reader :result
    # override on each platform
    # attr_reader :custom_status_check_func

    # override on each platform
    # custom define the whole async wait completely
    # attr_reader :custom_async_wait

    def validate
      super

      check_property :operation, Operation

      # for delete, the custom status method is generated, no need config.
      check_optional_property :status_check, Status
      check_optional_property :result, Result # not all async operations have result

      @timeout ||= 10 * 60
      check_optional_property :timeout, Integer
    end

    # Represents the operations (requests) issues to watch for completion
    class Operation < Api::ApiBasic
      attr_reader :path_parameter
      attr_reader :wait_ms

      def validate
        check_optional_property :path_parameter, Hash
        if @path_parameter
          @path_parameter.each {|k, v| check_property_value("async.operation.path_parameter:#{k}", v, String)}
        end

        @wait_ms ||= 1000
        check_optional_property :wait_ms, Integer

        @name ||= "async_query_api"

	@has_response = true

        super
      end
    end

    # Provides information to parse the result response to check operation
    # status
    class Status < Api::Object
      attr_reader :field
      attr_reader :complete
      attr_reader :pending

      def validate
        super
        check_property :field, String
        check_property :complete, Array
        check_optional_property :pending, Array
      end
    end

    # Represents the results of an Operation request
    class Result < Api::Object
      attr_reader :field # used to navigate the original resource id
      def validate
        super
        check_property :field, String
      end
    end
  end
end
