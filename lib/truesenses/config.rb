module Truesenses
  class Config
    attr_reader :password, :username, :protocol
    def initialize(options)
      p options
      @password = options['password']
      @username = options['username']
      @protocol = options['protocol'] || :http
      verify!
    end

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