require_relative('./film')
require_relative('./ticket')
require_relative('../db/sql_runner')

class Customer

attr_reader :id
attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @name = options['name']
    @funds = options['funds'].to_i()
  end

def save()


end


end
