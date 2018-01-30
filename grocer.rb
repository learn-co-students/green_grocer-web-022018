def consolidate_cart(cart)
  new = {}
  cart.each do |list|
    list.each do |item, info|
       if new[item].nil?
        new[item] = info
        new[item][:count] = 1
      else
        new[item][:count] += 1
      end
    end
  end
  new
end

def apply_coupons(cart, coupons)
  new = cart
  coupons.each do |coupon|
    item = coupon[:item]
    if new.keys.include?(item) && coupon[:num] <= new[item][:count]
      price = coupon[:cost]
      clearance = new[item][:clearance]
      count = (new[item][:count]/coupon[:num]).floor
      new["#{item} W/COUPON"] = {:price=> price, :clearance=> clearance, :count=> count}
      new[item][:count] = (new[item][:count] % coupon[:num])
    end
  end
  new
end

def apply_clearance(cart)
  new = cart
  cart.each do |item, info|
    if info[:clearance]
      price = info[:price] * 0.8
      new[item][:price] = price.round(2)
    end
  end
  new
end

def checkout(cart, coupons)
  cost = 0.00
  apply_clearance(apply_coupons(consolidate_cart(cart), coupons)).each do |item, info|
    cost += info[:price] * info[:count] end
  if cost > 100
    (cost*0.9).round(2) 
  else
    cost
  end
end