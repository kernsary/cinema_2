require_relative('customer')
require_relative('film')
require_relative('screening')
require_relative('../db/sql_runner')

class Ticket

  attr_reader :customer_id, :film_id, :screening_id, :id

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @customer_id = options['customer_id'].to_i()
    @film_id = options['film_id'].to_i()
    @screening_id = options['screening_id'].to_i()
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id, screening_id)
    VALUES ($1, $2, $3)
    RETURNING id;"
    values = [@customer_id, @film_id, @screening_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i()
    customer = find_customer()
    film = find_film()
    customer.funds -= film.price
    customer.update()
  end

  def find_customer()
    sql = "SELECT * FROM customers
    WHERE id = $1"
    values = [@customer_id]
    result = SqlRunner.run(sql, values)[0]
    return Customer.new(result)
  end

  def find_film()
    sql = "SELECT * FROM films
    WHERE id = $1"
    values = [@film_id]
    result = SqlRunner.run(sql, values)[0]
    return Film.new(result)
  end

  def update()
    sql = "UPDATE tickets
    SET (customer_id, film_id, screening_id) = ($1, $2, $3)
    WHERE id = $4;"
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def update_customer_id(new_id)
    @customer_id = new_id
    update()
  end

  def update_film_id(new_id)
    @film_id = new_id
    update()
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM tickets;"
    results = SqlRunner.run(sql)
    return self.map_tickets(results)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
  end

  def self.map_tickets(data)
    return data.map{|ticket| Ticket.new(ticket)}
  end

end
