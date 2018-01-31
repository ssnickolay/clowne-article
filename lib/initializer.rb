require 'bundler'
require 'active_record'
Bundler.require(:default)

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
Clowne.default_adapter = :active_record

require_relative './schema.rb'
require_relative './utils.rb'
require_relative './models.rb'

require_relative './cloners/shared_cloners.rb'
require_relative './cloners/a_order_cloner.rb'
# require_relative './cloners/b_order_cloner.rb'
# require_relative './cloners/c_order_cloner.rb'
