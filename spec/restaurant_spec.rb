require "restaurant"
require "date"

RSpec.describe RestaurantMenu do
  it "returns a list of hashes showing the item and prices of the dishes in the menu" do
  dish_1 = double(:dish, item: "Spaghetti", price: 10)
  dish_2 = double(:dish, item: "Lasagna", price: 12)
  dish_3 = double(:dish, item: "Salad", price: 7)
  restaurant_menu = RestaurantMenu.new(dish_1, dish_2, dish_3)
  expect(restaurant_menu.show_menu).to eq [{"item": "Spaghetti", "price": 10},{"item": "Lasagna", "price": 12},{"item": "Salad", "price": 7}]
  end 

  it "returns an empty receipt when no dishes are added and show_order is called" do
    dish_1 = double(:dish, item: "Spaghetti", price: 10)
    dish_2 = double(:dish, item: "Lasagna", price: 12)
    dish_3 = double(:dish, item: "Salad", price: 7)
    restaurant_menu = RestaurantMenu.new(dish_1, dish_2, dish_3)
    expect(restaurant_menu.show_order).to eq "Grand Total : 0"

  end

  it "returns a receipt when  dishes are added and show_order is called" do
    dish_1 = double(:dish, item: "Spaghetti", price: 10)
    dish_2 = double(:dish, item: "Lasagna", price: 12)
    dish_3 = double(:dish, item: "Salad", price: 7)
    restaurant_menu = RestaurantMenu.new(dish_1, dish_2, dish_3)
    restaurant_menu.add_to_order(dish_1,5)
    expect(restaurant_menu.show_order).to eq "Spaghetti...5...50\nGrand Total : 50"

  end

  it "returns a receipt when more dishes are added and show_order is called" do
    dish_1 = double(:dish, item: "Spaghetti", price: 10)
    dish_2 = double(:dish, item: "Lasagna", price: 12)
    dish_3 = double(:dish, item: "Salad", price: 7)
    restaurant_menu = RestaurantMenu.new(dish_1, dish_2, dish_3)
    restaurant_menu.add_to_order(dish_1,5)
    restaurant_menu.add_to_order(dish_2,3)
    expect(restaurant_menu.show_order).to eq "Spaghetti...5...50\nLasagna...3...36\nGrand Total : 86"
  end

  it "returns a receipt when dishes are added and some are removed and show_order is called" do
    dish_1 = double(:dish, item: "Spaghetti", price: 10)
    dish_2 = double(:dish, item: "Lasagna", price: 12)
    dish_3 = double(:dish, item: "Salad", price: 7)
    restaurant_menu = RestaurantMenu.new(dish_1, dish_2, dish_3)
    restaurant_menu.add_to_order(dish_1,5)
    restaurant_menu.add_to_order(dish_2,3)
    restaurant_menu.remove_from_order(dish_2,3)
    expect(restaurant_menu.show_order).to eq "Spaghetti...5...50\nGrand Total : 50"
  end

  it "returns a correct receipt when too many dishes are removed and show_order is called" do
    dish_1 = double(:dish, item: "Spaghetti", price: 10)
    dish_2 = double(:dish, item: "Lasagna", price: 12)
    dish_3 = double(:dish, item: "Salad", price: 7)
    restaurant_menu = RestaurantMenu.new(dish_1, dish_2, dish_3)
    restaurant_menu.add_to_order(dish_1,5)
    restaurant_menu.remove_from_order(dish_2,3)
    expect(restaurant_menu.show_order).to eq "Spaghetti...5...50\nGrand Total : 50"
  end
  it "sends a sms message when  dishes are added and make_order is called" do
    dish_1 = double(:dish, item: "Spaghetti", price: 10)
    dish_2 = double(:dish, item: "Lasagna", price: 12)
    dish_3 = double(:dish, item: "Salad", price: 7)
    restaurant_menu = RestaurantMenu.new(dish_1, dish_2, dish_3)
    restaurant_menu.add_to_order(dish_1,5)
    client = double(:client)
    time = double(:time)
    number = "+447908443916"
    allow(time).to receive(:strftime).with("%H:%M").and_return("15:03")
    messages_method = double(:fake_messages_method)
    allow(messages_method).to receive(:create).with(from: '+14783751112',
    to: number,
    body: "Thank you! Your order was placed and will be delivered before #{time.strftime("%H:%M")}")
    allow(client).to receive(:messages).and_return(messages_method)
    restaurant_menu.make_order(number,client,time)
  end
end 

RSpec.describe Dish do
  it "returns price of dish" do
    item = "Spaghetti"
    price = 10
    dish = Dish.new(item,price)
    expect(dish.price).to eq price
  end

  it "returns item of dish" do
    item = "Spaghetti"
    price = 10
    dish = Dish.new(item,price)
    expect(dish.item).to eq item
  end


end 
