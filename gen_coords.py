# Python script for generating plist items from a simple coords file
# For developers that want to add to the presets library
# Coords file format (examples under coords/, any file with extension ".coord")
# x y
# ... for n lines
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

# Uses a job file containing all arguments for coord generation, see example 'jobs.txt'
def main():
    filename = sys.argv[1]
    jobs = []
    
    with open(filename) as jobsfile:
        for line in jobsfile:
            job_fields = []
            split = line.strip().split("\"")
            for sp in split:
                if sp == " " or sp == "":
                    continue
                job_fields.append(sp)
                
            print(job_fields)
            jobs.append(job_fields)
    
    for job in jobs:
        name = job[0]
        description = job[1]
        image = job[2]
        coords_file = job[3]

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
        </dict>
        '''.format(name, description, image, coord_string)
        
        with open(coords_file.split(".")[0] + ".out", "w") as g:
            g.write(string)

if __name__ == "__main__":
    main()
