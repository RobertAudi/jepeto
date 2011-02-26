Jekyll Post Generator
=====================

This is a gem that is used to generate Jekyll post files with the
appropriate name and YAML Front Matter.

Usage
-----

You need to be in the same directory as the `_posts` directory, or in
the `_posts` directory itself to be able to use the generator. A `jp`
script is provided with the gem. When used without args, it will prompt
the user for a title.

Alternatively, you can either provide default options via a `.jprc` file
in your home directory, or pass the options directly via the command
line. For more info on that, type `jp --help`

Compatibility
-------------

Jepeto require Ruby 1.9+ and will be tested exclusively with Ruby
1.9.2+. MiniTest will be used instead of Test::Unit and until the
official version of Chronic is compatible with Ruby 1.9, the
`aaronh-chonic` gem will be used instead.

License
-------

The MIT License, also available in the `LICENSE.markdown` file.

Copyright (c) 2011 Aziz Light

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
