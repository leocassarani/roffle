def print_owing
  outstanding = 0.0

  print_banner

  @orders.each do |order|
    outstanding += order.amount
  end

  puts "name: #{@name}"
  puts "amount: #{outstanding}"
end

def print_banner
  puts "*************************"
  puts "***** Customer Owes *****"
  puts "*************************"
end
