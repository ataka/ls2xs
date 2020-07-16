DSTROOT=/tmp/ls2xs.dst

.PHONY : compile
compile:
	swift build --disable-sandbox -c release

.PHONY : prefix_install
prefix_install: compile
	sudo mkdir -p $(PREFIX)/bin
	sudo cp -p ./.build/release/ls2xsR $(PREFIX)/bin

.PHONY : xcodeproj
xcodeproj:
	swift package generate-xcodeproj

.PHONY : test
# test:
#	set -o pipefail && xcodebuild test -scheme ls2xs | xcpretty -c -r junit -o build/test-report.xml
