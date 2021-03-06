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
require 'provider/abstract_core'
require 'provider/property_override'

module Provider
  class Terraform < Provider::AbstractCore
    # Inserts custom code into terraform resources.
    class CustomCode < Api::Object
      # Collection of fields allowed in the CustomCode section for
      # Terraform.

      # All custom code attributes are string-typed.  The string should
      # be the name of a template file which will be compiled in the
      # specified / described place.
      #
      # ======================
      # schema.Resource stuff
      # ======================
      # Extra Schema Entries go below all other schema entries in the
      # resource's Resource.Schema map.  They should be formatted as
      # entries in the map, e.g. `"foo": &schema.Schema{ ... },`.
      attr_reader :extra_schema_entry
      # Resource definition code is inserted below everything else
      # in the resource's Resource {...} definition.  This may be useful
      # for things like a MigrateState / SchemaVersion pair.
      # This is likely to be used rarely and may be removed if all its
      # use cases are covered in other ways.
      attr_reader :resource_definition
      # ====================
      # Encoders & Decoders
      # ====================
      # The encoders are functions which take the `obj` map after it
      # has been assembled in either "Create" or "Update" and mutate it
      # before it is sent to the server.  There are lots of reasons you
      # might want to use these - any differences between local schema
      # and remote schema will be placed here.
      # Because the call signature of this function cannot be changed,
      # the template will place the function header and closing } for
      # you, and your custom code template should *not* include them.
      attr_reader :encoder
      # The update encoder is the encoder used in Update - if one is
      # not provided, the regular encoder is used.  If neither is
      # provided, of course, neither is used.  Similarly, the custom
      # code should *not* include the function header or closing }.
      # Update encoders are only used if object.input is false,
      # because when object.input is true, only individual fields
      # can be updated - in that case, use a custom expander.
      attr_reader :update_encoder
      # The decoder is the opposite of the encoder - it's called
      # after the Read succeeds, rather than before Create / Update
      # are called.  Like with encoders, the decoder should not
      # include the function header or closing }.
      attr_reader :decoder

      # =====================
      # Simple customizations
      # =====================
      # Constants go above everything else in the file, and include
      # things like methods that will be referred to by name elsewhere
      # (e.g. "fooBarDiffSuppress") and regexes that are necessarily
      # exported (e.g. "fooBarValidationRegex").
      attr_reader :constants
      # This code is run after the Create call succeeds.  It's placed
      # in the Create function directly without modification.
      attr_reader :post_create
      # This code is run before the Update call happens.  It's placed
      # in the Update function, just after the encoder call, before
      # the Update call.  Just like the encoder, it is only used if
      # object.input is false.
      attr_reader :pre_update
      # This code is run after the Update call happens.  It's placed
      # in the Update function, just after the call succeeds.
      # Just like the encoder, it is only used if object.input is
      # false.
      attr_reader :post_update
      # This code is run just before the Delete call happens.  It's
      # useful to prepare an object for deletion, e.g. by detaching
      # a disk before deleting it.
      attr_reader :pre_delete
      # This code replaces the entire import method.  Since the import
      # method's function header can't be changed, the template
      # inserts that for you - do not include it in your custom code.
      attr_reader :custom_import
      # This code is run just after the import method succeeds - it
      # is useful for parsing attributes that are necessary for
      # the Read() method to succeed.
      attr_reader :post_import
      # This code is used to check whether the async operation completes.
      attr_reader :async_create_complete
      # This code is used to check whether the async operation completes.
      attr_reader :async_update_complete

      def validate
        super

        check_optional_property :extra_schema_entry, String
        check_optional_property :resource_definition, String
        check_optional_property :encoder, String
        check_optional_property :update_encoder, String
        check_optional_property :decoder, String
        check_optional_property :constants, String
        check_optional_property :post_create, String
        check_optional_property :pre_update, String
        check_optional_property :post_update, String
        check_optional_property :pre_delete, String
        check_optional_property :custom_import, String
        check_optional_property :post_import, String
        check_optional_property :async_create_complete, String
        check_optional_property :async_update_complete, String
      end
    end
  end
end
