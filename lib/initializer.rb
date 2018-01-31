ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
Clowne.default_adapter = :active_record

require_relative './schema.rb'
require_relative './utils.rb'
require_relative './models.rb'
require_relative './cloners.rb'
