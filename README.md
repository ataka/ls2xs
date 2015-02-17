# LocalizableStrings2XibStrings

[![Circle CI](https://circleci.com/gh/ishkawa/LocalizableStrings2XibStrings.svg?style=svg)](https://circleci.com/gh/ishkawa/LocalizableStrings2XibStrings)

A command line tool that updates .strings of .xib and .storyboard using Localizable.strings.

![](http://blog.ishkawa.org/assets/misc/ls2xs.gif)


## Usage

- Enable base internationalization.
- Add Localizable.strings for each languages.
- Set keys of Localizable.strings to text values in .xib or .storyboard, as you set them to NSLocalizedString("key", "comment") in code.
- Add "New Run Script Phase" to "Build Phases" of your application target, and set contents: 

```shell
/path/to/ls2xs $TARGET_NAME
```

`ls2xc` generates .strings for .xib and .storyboard using `ibtool --generate-strings-file`.
Then, `ls2xc` replaces value of .strings with value of Localizable.strings if it matches key of Localizable.strings.


## Example

Suppose Main.storyboard(Base) has UILabel (Object ID: 4gA-LI-pd8, text: "hello").


### Input

- Localizable.strings(en): `"hello" = "Hello";`
- Localizable.strings(ja): `"hello" = "こんにちは";`


### Output

- Main.strings(en): `"4gA-LI-pd8.title" = "Hello";`
- Main.strings(ja): `"4gA-LI-pd8.title" = "こんにちは";`


## Contributing

Please file issues or send pull requests for anything you notice.

- Prefer pull request over issue because you must be a Cocoa developer.
- Write tests to prevent making regression.
- Keep in mind we make no primises that your proposal will be accepted.


## License

Copyright (c) 2015 Yosuke Ishikawa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
