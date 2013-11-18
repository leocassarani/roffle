def print_owing
  outstanding = 0.0

  puts "*************************"
  puts "***** Customer Owes *****"
  puts "*************************"

  @orders.each do |order|
    outstanding += order.amount
  end

  puts "name: #{@name}"
  puts "amount: #{outstanding}"
end
