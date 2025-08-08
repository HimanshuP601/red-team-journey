import sys

def to_little_endian_hex(s):
    return "0x" + s[::-1].encode().hex()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 endian.py <string>")
        sys.exit(1)
    
    input_str = sys.argv[1]
    print(to_little_endian_hex(input_str))

