#! /bin/sh

# This script invokes pod2cpanhtml to generate HTML from POD. 
# This is done so the rendering can be checked by eye. 

#~ pod2cpanhtml lib/Devel/Toolbox.pm html/Devel/Toolbox.html

mkdir -p html/Devel/Toolbox/Test
pod2cpanhtml lib/Devel/Toolbox/Test/Valet.pm html/Devel/Toolbox/Test/Valet.html

exit 0
