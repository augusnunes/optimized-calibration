def is_palind(s:str):
    s = s.lower()
    for i in range(len(s)):
        if not s[i] == s[-(i+1)]:
            return False
    return True

while True:
    print(is_palind(input()))