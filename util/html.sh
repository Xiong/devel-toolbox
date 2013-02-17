#! /bin/sh

# This script invokes pod2cpanhtml to generate HTML from POD. 
# This is done so the rendering can be checked by eye. 

pod2cpanhtml lib/Devel/Toolbox.pm html/Devel/Toolbox.html
pod2cpanhtml lib/Devel/Toolbox/New/Set.pm html/Devel/Toolbox/New/Set.html

exit 0
