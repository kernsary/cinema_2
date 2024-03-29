require_relative('customer')
require_relative('screening')
require_relative('ticket')
require_relative('../db/sql_runner')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @title = options['title']
    @price = options['price'].to_i()
  end

  def save()
    sql = "INSERT INTO films (title, price)
    VALUES ($1, $2)
    RETURNING id;"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i()
  end

  def update()
    sql = "UPDATE films
    SET (title, price) = ($1, $2)
    WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end


  # EXTENSION ----------------------------------

  def number_of_customers()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE tickets.film_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values).count
  end

  def screenings()
    sql = "SELECT * FROM screenings
    WHERE film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return Screening.map_screenings(result)
  end

  def most_popular_screening
    screenings_to_check = screenings()
    most_popular = [screenings_to_check.pop]
    screenings_to_check.each do |screening|
      if screening.tickets().count > most_popular[0].tickets().count
        most_popular = [screening]
      elsif screening.tickets().count == most_popular[0].tickets().count
        most_popular.push(screening)
      end
    end
    return most_popular
  end

  def self.all()
    sql = "SELECT * FROM films;"
    results = SqlRunner.run(sql)
    return self.map_films(results)
  end

  def self.delete_all()
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
  end

  def self.map_films(data)
    return data.map{|film| Film.new(film)}
  end

end
