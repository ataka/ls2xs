test:
	set -o pipefail && xcodebuild test -scheme ls2xs | xcpretty -c -r junit -o build/test-report.xml
