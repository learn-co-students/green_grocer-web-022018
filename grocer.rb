def consolidate_cart(cart)
  consolidated = {}
  cart.each do |item|
    item.each do |name, details|
      if consolidated.keys.include?(name) == false
        consolidated[name] = details.merge({:count => 1})
      else 
        consolidated[name][:count] += 1
      end 
    end 
  end 
  consolidated
end

def apply_coupons(cart, coupons)
 discount = {}
  coupons.each do |items|
    if cart.keys.include?(items[:item]) == true && cart[(items[:item])][:count] >= items[:num]
      discount[(items[:item])] = {
        :price => cart[(items[:item])][:price],
        :clearance => cart[(items[:item])][:clearance],
        :count => (cart[(items[:item])][:count] % items[:num])
        }
      discount["#{(items[:item])} W/COUPON"] = {
        :price => items[:cost],
        :clearance => cart[(items[:item])][:clearance],
        :count => (cart[(items[:item])][:count] - discount[(items[:item])][:count])/items[:num]
      }
    end 
  end 
  cart.each do |name, details|
      if discount.keys.include?(name) == false
        discount[name] = {
          :price => details[:price],
          :clearance => details[:clearance],
          :count => details[:count]
        }
      end 
    end 
  discount 
end

def apply_clearance(cart)
   cart.each do |name, details|
     if details[:clearance] == true
      details[:price] = (details[:price] * 0.8).round(2)
      
    end 
  end 
  cart
end

def checkout(cart, coupons)
  cart1 = consolidate_cart(cart)
  cart2 = apply_coupons(cart1,coupons)
  final = apply_clearance(cart2)
  total = 0
  final.each do |name,details|
    total += details[:price] * details[:count]
  end 
  total > 100 ? total * 0.9 : total
  
end
