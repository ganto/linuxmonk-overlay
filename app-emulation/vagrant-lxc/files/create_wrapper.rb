#!/usr/bin/env ruby

# Create the vagrant-lxc sudo-wrapper from the template.
# Roughly taken from lib/vagrant-lxc/command/sudoers.rb
#
# Michael Adam <obnox@samba.org>

# Adjusted for the use on Gentoo
#
# Reto Gantenbein <reto.gantenbein@linuxmonk.ch>

require 'rbconfig'
require 'tempfile'

require "vagrant/util/template_renderer"


class CreateWrapper
  class << self
    def run!(argv)
      raise "Argument missing" unless(argv)

      template_root = argv.shift
      wrapper_dst = "./vagrant-lxc-wrapper"

      wrapper_tmp = create_wrapper!(template_root)

      system "cp #{wrapper_tmp} #{wrapper_dst}"
      puts "#{wrapper_dst} created"
    end

    private

    # This requires vagrant 1.5.2+
    # https://github.com/mitchellh/vagrant/commit/3371c3716278071680af9b526ba19235c79c64cb
    def create_wrapper!(template_root)
      wrapper = Tempfile.new('lxc-wrapper').tap do |file|
        template = Vagrant::Util::TemplateRenderer.new(
          'sudoers.rb',
          :ruby_exec      => File.join(RbConfig::CONFIG['bindir'] + "/" + RbConfig::CONFIG["RUBY_INSTALL_NAME"]),
          :template_root  => template_root,
          :cmd_paths      => build_cmd_paths_hash,
          :pipework_regex => "/usr/lib64/ruby/gems/.+/gems/vagrant-lxc.+/scripts/pipework"
        )
        file.puts template.render
      end
      wrapper.close
      wrapper.path
    end

    def build_cmd_paths_hash
      {}.tap do |hash|
        %w( which cat mkdir cp chown chmod rm tar chown ip ifconfig brctl ).each do |cmd|
          hash[cmd] = `which #{cmd}`.strip
        end
        hash['lxc_bin'] = Pathname(`which lxc-create`.strip).parent.to_s
      end
    end
  end
end

CreateWrapper.run!(ARGV)
