require 'rack'
require 'browsr/resource'
require 'browsr/window'

class Browsr
  class NotImplemented < RuntimeError; end

  attr_reader :current_window
  attr_reader :medium

  def self.rack(app, options={})
    require 'browsr/rack'
    Browsr::Rack.use
    browsr = new
    browsr.extend Browsr::Rack::RackBrowsr
    browsr.initialize_rack(app, options)
    browsr
  end

  # @param [Hash] options
  #   An options hash with the following keys:
  #   * :css_medium_attributes:
  #     A hash as described for Browsr::CSS::Medium#new's description argument
  #
  #   The server_* values are relevant for browsrs decision on how to make what
  #   requests, and whether they're considered internal or external
  #   * :server_ip
  #   * :server_name
  #   * :server_port
  def initialize(options={})
    options         = options.dup
    @current_window = nil
    @medium         = CSS::Medium.new(options.delete(:css_medium_attributes) || {})
  end

  # @return [Browsr::Window]
  def visit(page)
    resource        = get(page)
    window          = Window.new(self, resource)
    @current_window = window

    window
  end

  # Also see Resource#get, as it handles requests relative to the resource
  # @return [Browsr::Resource]
  def get(absolute_path, headers=nil)
    raise NotImplemented
  end

  def inspect
    sprintf '#<%s>', self.class
  end
end
