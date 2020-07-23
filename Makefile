.PHONY : compile
compile:
	swift build --disable-sandbox -c release

.PHONY : prefix_install
prefix_install: compile
	mkdir -p $(PREFIX)/bin
	cp -p ./.build/release/ls2xs $(PREFIX)/bin

.PHONY : xcodeproj
xcodeproj:
	swift package generate-xcodeproj

.PHONY : test
# test:
#	set -o pipefail && xcodebuild test -scheme ls2xs | xcpretty -c -r junit -o build/test-report.xml

.PHONY : prepare_release
prepare_release:
	scripts/prepare_release.sh
.PHONY : prepare_hotfix
	scripts/prepare_hotfix.sh
