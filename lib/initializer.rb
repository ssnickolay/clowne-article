require 'bundler'
require 'active_record'
Bundler.require(:default)

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
Clowne.default_adapter = :active_record

require_relative './schema'
require_relative './utils'
require_relative './models'

require_relative './cloners/shared_cloners'
require_relative './cloners/a_order_cloner'
require_relative './cloners/b_order_cloner'
# require_relative './cloners/c_order_cloner.rb'
