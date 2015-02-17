DSTROOT=/tmp/ls2xs.dst

prefix_install:
	xcodebuild install -scheme ls2xs DSTROOT=$(DSTROOT)
	mkdir -p $(PREFIX)/bin
	cp -f $(DSTROOT)/usr/local/bin/ls2xs $(PREFIX)/bin/

test:
	set -o pipefail && xcodebuild test -scheme ls2xs | xcpretty -c -r junit -o build/test-report.xml
