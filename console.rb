require_relative('models/customer')
# require_relative('models/film')
# require_relative('models/ticket')

require('pry')

customer1 = Customer.new({'name' => 'Sinnie File', 'funds' => 100})
customer2 = Customer.new({'name' => 'Avid Goggler', 'funds' => 10})

customer1.save()
customer2.save()

binding.pry
nil
