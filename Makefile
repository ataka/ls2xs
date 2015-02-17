prefix_install:
	xcodebuild -scheme ls2xs
	cp -f build/Release/ls2xs $(PREFIX)/bin/

test:
	set -o pipefail && xcodebuild test -scheme ls2xs | xcpretty -c -r junit -o build/test-report.xml
