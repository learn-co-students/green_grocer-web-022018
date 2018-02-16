require "pry"

def consolidate_cart(cart)
  # code here
  output = {}
  cart.each do |item|
    item.each do |name, info|
      output[name] = info
      # output[name][count] = cart.count {|hash| hash[name] == info}
      output[name].update(count: cart.count {|hash| hash[name] == info})
    end
  end
  output
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each_with_index do |coupon, index|
    if cart.has_key? coupon[:item]
      if cart[coupon[:item]][:count] >= coupon[:num]
        cart[coupon[:item]][:count] -= coupon[:num]
        if cart.has_key? "#{coupon[:item]} W/COUPON"
          cart["#{coupon[:item]} W/COUPON"][:count] += 1
        else
          cart.update("#{coupon[:item]} W/COUPON" => {
            price: coupon[:cost],
            clearance: cart[coupon[:item]][:clearance],
            count: 1
            })
        end
        if cart[coupon[:item]][:count] == 0
          cart.delete([coupon[:item]])
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item, info|
    if info[:clearance]
      info[:price] = (info[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons=nil)
  # code here
  consolidated = consolidate_cart(cart)
  if coupons != nil
    consolidated = apply_coupons(consolidated, coupons)
  end
  consolidated = apply_clearance(consolidated)
  total = 0
  consolidated.each do |item, info|
    total += (info[:price] * info[:count])
  end
  if total > 100.00
    total = (total * 0.90).round(2)
  end
  total
end
