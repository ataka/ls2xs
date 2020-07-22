# ls2xs
<p>
    <a href="https://github.com/ataka/ls2xs/blob/develop/LICENSE">
        <img alt="GitHub license" src="https://img.shields.io/github/license/ataka/ls2xs"/>
    </a>
    <a href="https://docs.swift.org/swift-book/index.html">
        <img alt="Swift 5.2" src="https://img.shields.io/badge/Swift-5.2-orange.svg"/>
    </a>
    <a href="https://github.com/ataka/ls2xs/releases">
        <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/ataka/ls2xs">
    </a>
</p>

<!--
[![Circle CI](https://img.shields.io/circleci/project/ishkawa/ls2xs/master.svg?style=flat)](https://circleci.com/gh/ishkawa/ls2xs/tree/master)
-->

A command line tool that updates .strings of .xib and .storyboard using Localizable.strings.

## Installation

<!--
```
brew install ishkawa/formulae/ls2xs
```
-->

### Make

``` shellsession
$ git pull https://github.com/ataka/ls2xs.git
$ cd ls2xs
$ PREFIX=/usr/local make prefix_install
```

## Usage

- Enable base internationalization.
- Add `Localizable.strings` for each languages.
- Set keys of `Localizable.strings` to text values in .xib or .storyboard, as you set them to `NSLocalizedString(_:comment:)` in code.
- Add "New Run Script Phase" to "Build Phases" of your application target, and set contents: 

```shell
/usr/local/bin/ls2xs $TARGET_PATH
```

`ls2xc` generates .strings for .xib and .storyboard using `ibtool --generate-strings-file`.
Then, `ls2xc` replaces value of .strings with value of `Localizable.strings` if it matches key of `Localizable.strings`.


## Example

Suppose `Base.lproj/Main.storyboard` has `UILabel (Object ID: 4gA-LI-pd8, text: "hello")`.


### Input

- `en.lproj/Localizable.strings`: `"hello" = "Hello";`
- `ja.lproj/Localizable.strings`: `"hello" = "こんにちは";`


### Output

- `en.lproj/Main.strings`: `"4gA-LI-pd8.title" = "Hello";`
- `ja.lproj/Main.strings`: `"4gA-LI-pd8.title" = "こんにちは";`


## Contributing

Please file issues or send pull requests for anything you notice.

- Prefer pull request over issue because you must be a Cocoa developer.
- Write tests to prevent making regression.
- Keep in mind we make no primises that your proposal will be accepted.

## Attributions

This tool is powered by:

- [apple/swift\-argument\-parser](https://github.com/apple/swift-argument-parser)

## License

Copyright (c) 2015 Yosuke Ishikawa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<!-- Local Variables: -->
<!-- mode: gfm -->
<!-- End: -->
