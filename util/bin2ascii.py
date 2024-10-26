def binary_to_ascii_with_format(input_file, output_file):
    with open(input_file, 'rb') as binary_file, open(output_file, 'w') as ascii_file:
        byte = binary_file.read(1)
        byte_counter = 0
        line = []

        while byte:
            # Convert the byte to decimal and append it to the current line
            line.append(str(ord(byte)))

            # Check if we have 4 bytes in the current line
            if len(line) == 4:
                # Join the bytes with commas and write to the file
                ascii_file.write(','.join(line) + '\n')
                line = []  # Reset for the next line

            # Read the next byte
            byte = binary_file.read(1)

        # Write any remaining bytes if they don't fill a complete line
        if line:
            ascii_file.write(','.join(line) + '\n')

if __name__ == '__main__':
    # Example usage:
    input_file = 'splash.pal'
    output_file = 'splash_pal.txt'
    binary_to_ascii_with_format(input_file, output_file)
