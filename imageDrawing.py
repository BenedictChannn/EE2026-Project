import numpy as np
from PIL import Image

# Scales image down to desired dimension
# Convert scaled down image to pixel array 

# For PNG, sets color to (0,0,0) for transparent pixel
# Every other color +1 (Cap at 255)

# CHANGE THE IMAGE NAME AND FILE EXTENSION
image_name = "game_over"
extension = ".jpg"

# Change this to desired dimension to scale to
size = 96,64 # Screen dimension

file = open("data/" + image_name + ".txt", "w")
img = Image.open(image_name + extension)
print("Original size: ", end="")
print(img.size)

img.thumbnail(size, Image.LANCZOS)
img.save('images/small_' + image_name + extension)
arr = np.array(img)
print(np.shape(arr))

count = 0
file.write("wire [15:0] data [6143:0];\n")
for i in range(672):
    file.write("assign data[" + str(i) +"] = 16'b00001_000001_00111;\n")


for i in range(len(arr)):
    for j in range(len(arr[i])):
        if len(arr[i][j]) == 4:
            r, g, b, a = arr[i][j]
            file.write("assign data[" + str(672 + count) + "] = ")
            if (a < 100):
                file.write("16'b00000_000000_00000;\n")
            else:
                new_r = (r//8)+1
                new_g = (g//4)+1
                new_b = (b//8)+1

                new_r = 31 if (r//8)+1 > 31 else (r//8)+1 
                new_g = 63 if (g//4)+1 > 63 else (g//4)+1
                new_b = 31 if (b//8)+1 > 31 else (b//8)+1
                
                file.write("16'b" + '{0:05b}'.format(new_r) + "_" + '{0:06b}'.format(new_g) + "_" + '{0:05b}'.format(new_b) + ";")
                file.write("\n")
                
        elif len(arr[i][j]) == 3:
            r, g, b = arr[i][j]
            file.write("assign data[" + str(672 + count) + "] = ")
            new_r = (r//8)+1
            new_g = (g//4)+1
            new_b = (b//8)+1

            new_r = 31 if (r//8)+1 > 31 else (r//8)+1 
            new_g = 63 if (g//4)+1 > 63 else (g//4)+1
            new_b = 31 if (b//8)+1 > 31 else (b//8)+1
            
            file.write("16'b" + '{0:05b}'.format(new_r) + "_" + '{0:06b}'.format(new_g) + "_" + '{0:05b}'.format(new_b) + ";")
            file.write("\n")
            
        count += 1
        
    file.write("\n")
for i in range(672):
    file.write("assign data[" + str(5472 + i) +"] = 16'b00001_000001_00111;\n")

file.close()