"""
exemplo de como usar pilha pra passar 
um número da base 10 pra base 2
"""

from stack import Stack

def mudaBinario(numero10):
    s = Stack()
    while numero10 > 0:
        remainder = numero10%2
        s.push(remainder)
        numero10 //=2
    numero2 = ""
    while not s.is_empty():
        numero2 += str(s.pop())

    return numero2

numero = int(input())
print(mudaBinario(numero))
print(int(mudaBinario(numero), base=2)," = ",numero)