require_relative('models/customer')
require_relative('models/film')
# require_relative('models/ticket')

require('pry')

customer1 = Customer.new({'name' => 'Sinnie File', 'funds' => 100})
customer2 = Customer.new({'name' => 'Avid Goggler', 'funds' => 10})

customer1.save()
customer2.save()

film1 = Film.new({'title' => 'The Weeping Meadow Strikes Again', 'price' => 12})
film2 = Film.new({'title' => 'Star Wars Episode XXXVIII: May The Fans Be With Us', 'price' => 6})

film1.save()
film2.save()

binding.pry
nil
