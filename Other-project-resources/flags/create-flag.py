import os
from PIL import Image

# Define the fixed sizes
fixed_size = (76, 45)
half_size = (38, 22)

# Get the current directory
directory = os.path.dirname(os.path.abspath(__file__))

# Loop through all files in the directory
for filename in os.listdir(directory):
    if filename.endswith("-o.png"):
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
        