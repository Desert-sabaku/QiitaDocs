require "digest"

input = Time.now.to_s
hash_value = Digest::SHA256.hexdigest(input)[0, 20]

puts hash_value
