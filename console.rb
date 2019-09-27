require_relative('models/customer')
# require_relative('models/film')
# require_relative('models/ticket')

require('pry')

customer1 = Customer.new({'name' => 'Sinnie File', 'funds' => 100})

customer1.save()

binding.pry
nil
