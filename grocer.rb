def consolidate_cart(cart)
  cart.each_with_object({}) do |item, result|
    item.each do |name, description|
      if !result[name]
        description[:count] = 1
        result[name] = description
      else 
        description[:count] += 1
      end
    end
  end
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart[item_name] && cart[item_name][:count] >= coupon[:num]
      if !cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{item_name} W/COUPON"][:clearance] = cart[item_name][:clearance]
      else 
        cart["#{item_name} W/COUPON"][:count] += 1
      end
    cart[item_name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item_name, description|
    if description[:clearance] 
      new_price = description[:price] * 0.80
      description[:price] = new_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  cart_w_coupons = apply_coupons(consolidated_cart, coupons)
  cart_w_clearence = apply_clearance(cart_w_coupons)
  total = 0
  cart_w_clearence.each do |item_name, description|
    total += description[:count] * description[:price]
  end 
  if total > 100
    total = total * 0.90
  end
  total 
end
