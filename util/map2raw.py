import sys
import struct

def load_tilemap(file_path, clut, tileset):
    # Ensure clut and tileset are within the valid range
    if not (0 <= clut < 4):
        raise ValueError("CLUT must be between 0 and 3 (2 bits).")
    if not (0 <= tileset < 8):
        raise ValueError("TileSet must be between 0 and 7 (3 bits).")

    # Construct the first byte based on the CLUT and TileSet
    # The format of the byte is: 00000CCCTTT (3 bits TileSet, 2 bits CLUT)
    first_byte = (clut << 3) | tileset

    # Open and read the comma-delimited file
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Prepare the new list to hold the converted data
    converted_tilemap = []

    for line in lines:
        # Split the line by commas and strip any extra spaces/newlines
        bytes_in_line = line.strip().split(',')

        # Convert each byte into two bytes
        for byte_str in bytes_in_line:
            byte_value = int(byte_str.strip())

            # Append the constructed first byte and the original byte_value
            converted_tilemap.append((first_byte, byte_value))

    return converted_tilemap

def save_converted_tilemap_binary(output_path, converted_tilemap):
    with open(output_path, 'wb') as binary_file:
        for first_byte, second_byte in converted_tilemap:
            # Write the bytes directly to the binary file
            binary_file.write(struct.pack('B', second_byte))
            binary_file.write(struct.pack('B', first_byte))


if __name__ == "__main__":
    # Example of calling the script
    # First argument: input file path
    # Second argument: CLUT (integer)
    # Third argument: TileSet (integer)
    if len(sys.argv) != 4:
        print("Usage: python tilemap_converter.py <input_file> <CLUT> <TileSet>")
        sys.exit(1)

    input_file = sys.argv[1]
    clut = int(sys.argv[2])
    tileset = int(sys.argv[3])

    # Load and convert the tilemap
    converted_tilemap = load_tilemap(input_file, clut, tileset)

    # Output binary file for the converted map
    output_file = "lvl1.map"

    # Save the converted map to a binary file
    save_converted_tilemap_binary(output_file, converted_tilemap)

    print(f"Converted tile map saved to {output_file} in binary format.")
