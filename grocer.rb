def consolidate_cart(cart)
  newcart = {}
  foodlist = []
  cart.each do |foods|
    foods.each do |food, details|
      foodlist << food
      newcart[food] = details
      details[:count] = foodlist.count(food)
    end 
  end 
  newcart
end 

def apply_coupons(cart, coupons)
  newcart = cart.dup
  couponfoods = []
  cart.each do |food, info|
    coupons.each do |coupon|
      if food == coupon[:item] 
        if couponfoods.include?(food) && newcart[food][:count] >= coupon[:num] 
          newcart["#{food} W/COUPON"][:count] += 1 
          newcart[food][:count] = newcart[food][:count] - coupon[:num]
        elsif newcart[food][:count] >= coupon[:num] 
          couponfoods << food
          newcart["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[food][:clearance], :count => 1}
          newcart[food][:count] = newcart[food][:count] - coupon[:num]
        end 
      end
    end
  end
  newcart
end


def apply_clearance(cart)
  cart.each do |food, details|
    if details[:clearance] == true
      details[:price] = (0.8*details[:price]*10).round/10.0
    end 
  end 
  cart
end

def checkout(cart, coupons)
  newcart = consolidate_cart(cart)
  newcart = apply_coupons(newcart,coupons)
  newcart = apply_clearance(newcart)
  total = 0 
  newcart.each do |food, details|
    total = total + details[:price] * details[:count]
  end
  if total > 100
    total = total*0.9
  end 
  total
end
