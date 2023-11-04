import numpy as np
from PIL import Image, ImageDraw, ImageFont

def create_entry(text, width, height, font_size, text_color, shadow_color, center):
    # file_name = "{0}_w{1}_h{2}_{3}".format(text, width, height, "center" if center else "left")
    file = open("data/" + "lvl 1 lvl 2" + ".txt", "w")
    print("Making entry for '{0}'".format(text))

    img = Image.new('RGBA', (width, height), "Black")
    font_path = r"C:\Users\bened\Downloads\pixel_lcd7\pixel_lcd_7.ttf"
    font = ImageFont.truetype(font_path, font_size)
    draw = ImageDraw.Draw(img)

    textlen = draw.textlength(text, font)
    if not center:
        draw.line([2, 10, textlen, 10])

    # Offset for the main text
    main_offset_x = 48 - textlen // 2 if center else 2
    main_offset_y =11

    # Offset for the shadow or outline
    shadow_offset_x = main_offset_x + 1  # Adjust this value for the desired shadow offset
    shadow_offset_y = main_offset_y + 1  # Adjust this value for the desired shadow offset

    # Draw the shadow or outline text
    draw.text((shadow_offset_x, shadow_offset_y), text, font=font, fill=shadow_color)
    # Draw the main text on top of the shadow or outline
    draw.text((main_offset_x, main_offset_y), text, font=font, fill=text_color)

    img.save("images/" + "lvl 1 lvl 2" + ".png")
    data = np.array(img)
    print(np.shape(data))

    count = 0
    pixel_count = len(data) * len(data[0]) - 1
    file.write("wire [15:0] data [{0}:0];\n".format(pixel_count))

    for i in range(len(data)):
        for j in range(len(data[i])):
            r, g, b, a = data[i][j]
            file.write("assign data[3072+" + str(count) + "] = ")
            file.write("16'b" + '{0:05b}'.format(r // 8) + "_" + '{0:06b}'.format(g // 4) + "_" + '{0:05b}'.format(b // 8) + ";")
            file.write('\n')
            count += 1
    file.close()

width = 96
welcome_color = (255, 255, 0, 255)  # Yellow color (RGBA format)
start_color = (255, 0, 0, 255) # Red Color (RGBA format)
shadow_welcome_color = (255, 0, 0, 255)  # Shadow color (RGBA format)
shadow_start_color = (0, 0, 255, 255)  # Shadow color (RGBA format)

# # Welcome screen with a 3D effect
# create_entry("Welcome to", width, 16, 9, welcome_color, shadow_welcome_color, center=True)
# create_entry("Brick Breaker!", width, 16, 9, welcome_color, shadow_welcome_color, center=True)
# create_entry("Press btnC to start", width, 32, 6, start_color, shadow_start_color, center=True)
create_entry("> LVL 1   LVL 2", width, 32, 7, start_color, shadow_start_color, center=True)