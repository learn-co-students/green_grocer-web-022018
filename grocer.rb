def consolidate_cart(cart)
    # code here
    hash = {}
    cart.each do |i|
        i.each do |k, v|
            if hash.has_key?(k)
                hash[k][:count] += 1
                else
                hash[k] ||= v
                hash[k][:count] = 1
            end
        end
    end
    hash
end

def apply_coupons(cart, coupons)
    # code here
    coupons.each do |el|
        item = el[:item]
        name = "#{item} W/COUPON"
        if cart.has_key?(item) && cart[item][:count] >= el[:num]
            if cart[name]
                cart[name][:count] += 1
                else
                cart[name] = {:price => el[:cost]}
                cart[name][:clearance]= cart[item][:clearance]
                cart[name][:count] = 1
            end
            cart[item][:count] -= el[:num]
        end
    end
    cart
end
def apply_clearance(cart)
    # code here
    cart.each do |k, v|
        v.each do |k2, v2|
            if k2 == :clearance
                if v2 == true
                    clearance = cart[k][:price] * 20/100
                    cart[k][:price] -= clearance
                end
            end
        end
    end
    cart
end


def checkout(cart, coupons)
    # code here
    consolidate = consolidate_cart(cart)
    coupon = apply_coupons(consolidate, coupons)
    final = apply_clearance(coupon)
    total = 0
    final.each do |k, v|
        total += v[:price] * v[:count]
        puts v
        puts total
    end
    if total > 100
        total -= total * 10/100
    end
    total.round(2)
end
