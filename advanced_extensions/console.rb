require_relative('models/customer')
require_relative('models/film')
require_relative('models/screening')
require_relative('models/ticket')

require('pry')

Ticket.delete_all()
Screening.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Sinnie File', 'funds' => 100})
customer2 = Customer.new({'name' => 'Avid Goggler', 'funds' => 50})
customer3 = Customer.new({'name' => 'Rid Skwerr', 'funds' => 30})
customer4 = Customer.new({'name' => 'Rank Bajin', 'funds' => 950})

customer1.save()
customer2.save()
customer3.save()
customer4.save()

film1 = Film.new({'title' => 'The Weeping Meadow Strikes Again', 'price' => 12})
film2 = Film.new({'title' => 'Star Wars Episode XXXVIII: May The Fans Be With Us', 'price' => 6})

film1.save()
film2.save()

screening1 = Screening.new({'film_id' => film1.id, 'screening_time' => '18:30', 'capacity' => 3})
screening2 = Screening.new({'film_id' => film2.id, 'screening_time' => '18:00', 'capacity' => 3})
screening3 = Screening.new({'film_id' => film2.id, 'screening_time' => '21:00', 'capacity' => 3})

screening1.save()
screening2.save()
screening3.save()

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id, 'screening_id' => screening1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id, 'screening_id' => screening1.id})
ticket3 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film2.id, 'screening_id' => screening2.id})
ticket4 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film2.id, 'screening_id' => screening2.id})
ticket5 = Ticket.new({'customer_id' => customer4.id, 'film_id' => film1.id, 'screening_id' => screening1.id})
ticket6 = Ticket.new({'customer_id' => customer4.id, 'film_id' => film2.id, 'screening_id' => screening2.id})

ticket1.save()
ticket2.save()
ticket3.save()
ticket4.save()
ticket5.save()
ticket6.save()

binding.pry
nil
