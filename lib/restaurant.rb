require 'twilio-ruby'
# As a customer
# So that I can check if I want to order something
# I would like to see a list of dishes with prices.

# As a customer
# So that I can order the meal I want
# I would like to be able to select some number of several available dishes.

# As a customer
# So that I can verify that my order is correct
# I would like to see an itemised receipt with a grand total.

# As a customer
# So that I am reassured that my order will be delivered on time
# I would like to receive a text such as "Thank you! Your order was placed and will be delivered before 18:52" after I have ordered.

account_sid = 'AC005a72973d248c56b88aff7bd78f1422'
auth_token = 'c8e8c4fdbbf94c72c6acc43d7b5a4b92'

# @client = Twilio::REST::Client.new account_sid, auth_token
# myLogger = Logger.new(STDOUT)
# myLogger.level = Logger::DEBUG
# @client.logger = myLogger

# @client.messages.create(
#   from: '+14783751112',
#   to: '+447908443916',
#   body: 'Hi tayanne!'
# )


class RestaurantMenu
  attr_accessor :dishes, :order

  def initialize(*dishes)
    # @dishes is a list of dish objects
    # @order is a hash with the format {dish_1: amount_1, dish_2: amount_2 ...}
    @order = Hash.new(0)
    @dishes = dishes
    
  end

  def show_menu
    # return list of items and prices as a hash in the following format {item:item, price:price}
    @dishes.map{|dish| {"item": dish.item, "price": dish.price}}
  end 

  def show_order
    # shows list of items in order
    # returns a string of the order with the following format
    # item_name...number...total
    # item_name...number...total
    # ..........................
    # ..........................
    # ..........................
    # Grand Total : Grand Total
    grand_total = 0
    receipt = ""
    @order.each do |dish, amount| 
      dish_total = dish.price*amount
      grand_total += dish_total
      receipt+="#{dish.item}...#{amount}...#{dish_total}\n"
    end 
    receipt+="Grand Total : #{grand_total}"
  end

  def make_order(number,client,time)
    client.messages.create(
      from: '+14783751112',
      to: number,
      body: message(time))
  end 

  def message(time)
    "Thank you! Your order was placed and will be delivered before #{time.strftime("%H:%M")}"
  end


  
  def add_to_order(dish, amount = 1)
    # adds dish to order
    @order[dish] += amount

  end
  def remove_from_order(dish, amount = 0)
    # adds dish to order
    @order[dish] -= amount
    if @order[dish]<=0
      @order.delete(dish)
    end 
  end
end 


class Dish
  def initialize(item,price)
    @item = item
    @price = price
  end 

  def price
    @price
    #returns price of item
  end 

  def item
    @item
    # returns name of item
  end 
end 
