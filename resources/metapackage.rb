actions :create

attribute :name, :name_attribute => true, :kind_of => String
attribute :depends, :kind_of => Array, :default => []
attribute :version, :kind_of => String, :default => '0.01'

# attribute :repo, :kind_of => String
# attribute :desc, :kind_of => String

def initialize(name, run_context=nil)
  super
  @action = :create
end

