import pyhash as ph 


# Non cryptographic hash functions (Murmur and FNV)
fnv = ph.fnv1_32()
murmur = ph.murmur3_32()

# Calculate the output of FNV and Murmur hash functions for pikachu and chamander

bit_vector = [0]*20

fnv_pika = fnv("Pikachu")%20
murmur_pika = murmur("Pikachu")%20

fnv_char = fnv("Charmander")%20
murmur_char = murmur("Charmander")%20

print("fnv_pika\t",fnv_pika)
print("fnv_char\t",fnv_char)
print("murmur_pika\t",murmur_pika)
print("murmur_char\t",murmur_char)


bit_vector[fnv_char] = 1
bit_vector[fnv_pika] = 1

bit_vector[murmur_char] = 1
bit_vector[murmur_pika] = 1
print(bit_vector)

# Se um deles der 0 ou os dois, o item não está no bloom filter