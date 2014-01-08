#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2014, Balanced, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name 'brache'

dependency 'pip'

# for lxml
dependency 'libxml2'
dependency 'libxslt'

source git: 'git@github.com:balanced/brache.git'
version ENV['BRACHE_VERSION'] || 'use-sterling'

relative_path 'brache'

always_build true

build do
  block do
    project = self.project
    if project.name == 'brache'
      shell = Mixlib::ShellOut.new('git describe --tags', cwd: self.project_dir)
      shell.run_command
      if shell.exitstatus == 0
        build_version = shell.stdout.chomp
        project.build_version build_version
        project.build_iteration ENV['BRACHE_PACKAGE_ITERATION'] ? ENV['BRACHE_PACKAGE_ITERATION'].to_i : 1
      end
    end
  end

  command "#{install_dir}/embedded/bin/pip install --install-option=--prefix=#{install_dir}/embedded ."
end
