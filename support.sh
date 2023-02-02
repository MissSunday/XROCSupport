
#!/bin/sh



cd Example/

package=1 source=1 pod install

cd ..
package=1 source=1 pod package XROCSupport.podspec \
--force \
--no-mangle \
--exclude-deps \
--configuration=Release \

