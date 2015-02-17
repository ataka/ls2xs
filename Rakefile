task :cidebug do
  path = `xcodebuild test -scheme ls2xs OBJROOT=build GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES 2>&1 >/dev/null | grep "log file at [^)]*" -o | sed -e 's/log file at//g'`
  puts "path: " + path
  if path
    sh "cat #{path}"
  end
end
