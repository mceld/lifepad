import sys

#
# 1 -> name
# 2 -> description
# 3 -> image
# 4 -> coords file
#

def main():
    if len(sys.argv) != 5:
        print("wrong args")
        return

    name = sys.argv[1]
    description = sys.argv[2]
    image = sys.argv[3]
    coords_file = sys.argv[4]

    coords = []

    with open(coords_file) as f:
        for line in f:
            split = line.split()
            coords.append([split[0], split[1]])

    

if __name__ == "__main__":
    main()
