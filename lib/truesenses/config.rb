module Truesenses
  class Config
    attr_reader :password, :username, :protocol, :origin, :deliver
    
    # :username
    # :password
    # :protocol :http or :https, defaults to :http
    # :origin default origin ID of text message
    # :deliver true|false, false turns on the TEST mode of truesenses API
    def initialize(options)
      options = options.stringify_keys
      @password = options['password']
      @username = options['username']
      @protocol = options['protocol'] || :http
      @origin = options['origin']
      @deliver = options.has_key?('deliver') ? options['deliver'] : true
      verify!
    end
    
    # Load config from a YAML file
    # if root is specified, then this root key is used (useful when you store different configurations
    # in one YAML file: Config.load('somefile.yml', RAILS_ENV))
    def self.load(filename, root = nil)
      data = YAML.load_file(filename)
      Config.new(root ? data[root] : data)
    end


    private
    def verify!
      raise ArgumentError.new('Please specify a password with password option') if self.password.nil?
      raise ArgumentError.new('Please specify a username with username option') if self.username.nil?
      raise ArgumentError.new('protocol must either of :http or :https') unless [:https, :http].include?(self.protocol)
    end
  end
end