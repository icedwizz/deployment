arr = [2,4,5,7,9]
arr_2d = [[1,2],[3,4]]
 
#printing the array
print("The Array is : ")
for i in arr:
    print(i, end = ' ')
 
#printing the 2D-Array
print("\nThe 2D-Array is:")
for i in arr_2d:
    for j in i:
        print(j, end=" ")
    print()
