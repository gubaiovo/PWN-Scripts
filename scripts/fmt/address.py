# 让%p的输出更直观
string = "0x7ffde92e4e300x300x7f9c60c8d1f20x190x190x7025702570257025"
i = 0
num = 0
while i < len(string):
    if string[i] == "0" and string[i+1] == "x" or string[i] == "(":
            print(f"\n{num}: ", end="")
            num += 1
    print(string[i], end="")
    
    i += 1
print("")

'''
0: 0x7ffde92e4e30
1: 0x30
2: 0x7f9c60c8d1f2
3: 0x19
4: 0x19
5: 0x7025702570257025
'''