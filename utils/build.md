# Build a deb package
Clean the target directory

    ./utils/build.sh clean

Prepare the debian directory structure

    ./utils/build.sh prepare

Package the application into a .deb file

    ./utils/build.sh package
    
    # Or with a provided specific name of the package file
    ./utils/build.sh package -n <package_name>

Deploy the .deb file to a repository (Only Nexus currently supported.)

    ./utils/build.sh deploy -u <username> -p <password> -r <repository> -n <package_name>
