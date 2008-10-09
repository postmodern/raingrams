= Raingrams

* http://raingrams.rubyforge.org/
* Postmodern Modulus III (postmodern.mod3@gmail.com)

== DESCRIPTION:
  
Raingrams is a flexible and general-purpose ngrams library written in Ruby.
Raingrams supports ngram sizes greater than 1, text/non-text grams, multiple
parsing styles and open/closed vocabulary models.

== FEATURES:
  
* Supports ngram sizes greater than 1.
* Supports text and non-text grams.
* Supports Open and Closed vocabulary models.
* Supports calculating the similarity and commonality of sample text against
  specified models.
* Supports generating random text from models.

== REQUIREMENTS:

* Hpricot

== INSTALL:

  $ sudo gem install raingrams

== EXAMPLES:

* Train a model with ycombinator comments:

  require 'raingrams'
  require 'hpricot'
  require 'open-uri'
  
  include Raingrams
  
  model = BigramModel.build do |model|
    doc = Hpricot(open('http://news.ycombinator.org/newcomments'))
    doc.search('span.comment') do |p|
      model.train_with_text(p.inner_text)
    end
  end

* Update a trained model:

  model.train_with_text %{Interesting videos. Anders talks about functional
    support on .net, concurrency, immutability. Guy Steele talks about
    Fortress on JVM. Too bad they are afraid of macros (access to AST),
    though Steele does say Fortress has some support.}

  model.refresh

* Generate a random sentence:

  model.random_sentence
  # => "OTOOH if you use slicehost even offer to bash Apple makes it will
  exit and its 38 month ago based configuration of little networks created."

== LICENSE:

The MIT License

Copyright (c) 2007-2008 Hal Brodigan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
