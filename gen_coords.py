import sys

#
# 1 -> name
# 2 -> description
# 3 -> image
# 4 -> coords file
#

def coords_to_string(coord):
    return (
        '''
            <array>
                <integer>{0}</integer>
                <integer>{1}</integer>
            </array>'''.format(coord[0], coord[1])
    )


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
            
            
    coord_string = ""
    for coord in coords:
        coord_string += coords_to_string(coord)
        
        
    string = '''
    <dict>
        <key>name</key>
        <string>{0}</string>
        <key>description</key>
        <string>{1}</string>
        <key>image</key>
        <string>{2}</string>
        <key>coords</key>
        <array>
        {3}
        </array>
    </dict>'''.format(name, description, image, coord_string)
    
    with open("coord.out", "w") as g:
        g.write(string)

if __name__ == "__main__":
    main()
