require 'pry'

def consolidate_cart(cart)
  consolidated = {}
  cart.each do |item|
    item.each do |name, details|
      consolidated[name] ||= {}
      consolidated[name][:count] ||= 0
      consolidated[name][:count] += 1
      details.each do |key, value|
        consolidated[name][key] = value
      end
    end
  end
  consolidated
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
      if cart[name] && cart[name][:count] >= coupon[:num]
        with_coupon = "#{name} W/COUPON"
        if cart[with_coupon]
          cart[with_coupon][:count] += 1
        else
          cart[with_coupon] = {}
          cart[with_coupon][:price] = coupon[:cost]
          cart[with_coupon][:clearance] = cart[name][:clearance]
          cart[with_coupon][:count] = 1
      end
          cart[name][:count] = cart[name][:count] - coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, values|
    if values[:clearance] == true
        values[:price] = (values[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  pre_final = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  pre_final.each do |item, values|
    total += (values[:price] * values[:count])
  end
  if total > 100
    return (total * 0.9).round(2)
  else
    return total
  end
end
