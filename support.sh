
#!/bin/sh
cd Example/

source=1 pod install

cd ..
source=1 pod package XROCSupport.podspec \
--force \
--no-mangle \
--exclude-deps \
--configuration=Release \

