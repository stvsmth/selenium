# Licensed to the Software Freedom Conservancy (SFC) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The SFC licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Selenium
  module WebDriver
    module IE
      class Server

        STOP_TIMEOUT = 5

        def self.get(opts = {})
          binary = IE.driver_path || Platform.find_binary("IEDriverServer")

          if binary
            new binary, opts
          else
            raise Error::WebDriverError,
              "Unable to find standalone executable. Please download the IEDriverServer from http://selenium-release.storage.googleapis.com/index.html and place the executable on your PATH."
          end
        end

        attr_accessor :log_level, :log_file

        def initialize(binary_path, opts = {})
          Platform.assert_executable binary_path

          @binary_path = binary_path
          @process = nil

          opts = opts.dup

          @log_level      = opts.delete(:log_level)
          @log_file       = opts.delete(:log_file)
          @implementation = opts.delete(:implementation)

          unless opts.empty?
            raise ArgumentError, "invalid option#{'s' if opts.size != 1}: #{opts.inspect}"
          end

        end

        def start(port, timeout)
          return @port if running?

          @port = port

          @process = ChildProcess.new(@binary_path, *server_args)
          @process.io.inherit! if $DEBUG
          @process.start

          unless SocketPoller.new(Platform.localhost, @port, timeout).connected?
            raise Error::WebDriverError, "unable to connect to IE server within #{timeout} seconds"
          end

          Platform.exit_hook { stop }

          @port
        end

        def stop
          if running?
            @process.stop STOP_TIMEOUT
          end
        end

        def port
          @port
        end

        def uri
          "http://#{Platform.localhost}:#{port}"
        end

        def running?
          @process && @process.alive?
        end

        private

        def server_args
          args = ["--port=#{@port}"]

          args << "--log-level=#{@log_level.to_s.upcase}" if @log_level
          args << "--log-file=#{@log_file}" if @log_file
          args << "--implementation=#{@implementation.to_s.upcase}" if @implementation

          args
        end

      end # Server
    end # IE
  end # WebDriver
end # Selenium
