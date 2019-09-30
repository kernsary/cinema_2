require_relative('./film')
require_relative('./screening')
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
    sql = "INSERT INTO customers
    (name, funds) VALUES ($1, $2)
    RETURNING id;"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i()
  end

  def update()
    sql = "UPDATE customers
    SET (name, funds) = ($1, $2)
    WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON films.id = tickets.film_id
    WHERE tickets.customer_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    films = Film.map_films(results)
    return films.map{|film| film.title}
  end

  def check_funds()
    sql = "SELECT funds FROM customers
    WHERE id = $1"
    values = [@id]
    return SqlRunner.run(sql, values)[0]['funds'].to_i()
  end

  def number_of_tickets()
    sql = "SELECT * FROM tickets
    WHERE customer_id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).count
  end

  def get_screening(screening_id)
    sql = "SELECT * FROM screenings
    WHERE id = $1;"
    values = [screening_id]
    result = SqlRunner.run(sql, values)[0]
    return Screening.new(result)
  end

  def get_film(screening_id)
    screening = get_screening(screening_id)
    sql = "SELECT * FROM films
    WHERE id = $1"
    values = [screening.get_film_id]
    result = SqlRunner.run(sql, values)[0]
    return Film.new(result)
  end

  def customer_wants_ticket(screening_id)
    screening = get_screening(screening_id)
    film = get_film(screening_id)
    if screening.tickets.count >= screening.capacity
      return "Sorry, that screening is sold out."
    elsif check_funds < film.price
      return "Sorry, you don't have enough money."
    end
    new_ticket = Ticket.new({'customer_id' => @id, 'film_id' => film.id, 'screening_id' => screening_id})
    new_ticket.save()
  end

  def self.all()
    sql = "SELECT * FROM customers;"
    results = SqlRunner.run(sql)
    return self.map_customers(results)
  end

  def self.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end

  def self.one_film_customers()
    names_of_customers = []
    all_customers = self.all()
    all_customers.each do |customer|
      if customer.films.count == 1
        names_of_customers.push(customer.name)
      end
    end
    return names_of_customers
  end

  def self.map_customers(data)
    return data.map{|customer| Customer.new(customer)}
  end

end
