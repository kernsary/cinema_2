require_relative('film')
require_relative('ticket')
require_relative('../db/sql_runner')

class Screening

  attr_reader :id, :film_id
  attr_accessor :screening_time, :capacity

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @film_id = options['film_id'].to_i()
    @screening_time = options['screening_time']
    @capacity = options['capacity'].to_i()
  end

  def save()
    sql = "INSERT INTO screenings
    (film_id, screening_time, capacity)
    VALUES ($1, $2, $3)
    RETURNING id;"
    values = [@film_id, @screening_time, @capacity]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i()
  end

  def tickets()
    sql = "SELECT * FROM tickets
    WHERE screening_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return Ticket.map_tickets(result)
  end

  def self.all()
    sql = "SELECT * FROM screenings;"
    results = SqlRunner.run(sql)
    return self.map_screenings(results)
  end

  def self.delete_all()
    sql = "DELETE FROM screenings;"
    SqlRunner.run(sql)
  end

  def self.map_screenings(data)
    return data.map{|screening| Screening.new(screening)}
  end


end
