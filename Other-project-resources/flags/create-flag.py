import os
from PIL import Image

# language we are interested in
# SWEDISH FLAG IS DEFFERENT - draw a 50% grey line around it as it is similar blue than the background
language = "sv"

# Define the fixed sizes - CHANGE THESE AS NEEDED for different sizes
# default (240x240) resources: (40, 24)
# 320x360 resources: (60, 36)
# 208x208 resources: (36, 22)
# 218x218 resources: (36, 22)
# 260x260 resources: (43, 26) (22, 13)
# 280x280 resources: (47, 28) (24, 14)
# 360x360 resources: (60, 36)
# 390x390 resources: (65, 39) (33, 20)
# 416x416 resources: (69, 42) (35, 21)
# 454x454 resources: (76, 45) (38, 22)
# semioctagon resources: (36, 22) - THESE ARE DIFFERENT!!! - BLACK AND WHITE - Arial 14 - AND RECREATE ALL with next lang IN THIS FORMAT TO LOOK SAME
fixed_size = (76, 45)
half_size = (38, 22)

# Get the current directory
directory = os.path.dirname(os.path.abspath(__file__))

# Loop through all files in the directory
for filename in os.listdir(directory):
    # Skip files that do not match the language or are not in the expected format
    if not filename.startswith(language) or not filename.endswith("-o.png"):
        continue

    # Open the image
    img = Image.open(os.path.join(directory, filename))
    
    # Resize to fixed size and save
    img_resized = img.resize(fixed_size, Image.LANCZOS)
    new_filename = filename.replace("-o.png", ".png")
    img_resized.save(os.path.join(directory, new_filename))
    
    # Resize to half size and save
    img_half_resized = img.resize(half_size, Image.LANCZOS)
    new_half_filename = filename.replace("-o.png", "S.png")
    img_half_resized.save(os.path.join(directory, new_half_filename))
        