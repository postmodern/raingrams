= Raingrams

* http://raingrams.rubyforge.org/
* Postmodern (postmodern.mod3 at gmail.com)

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

* {nokogiri}[http://nokogiri.rubyforge.org/] >= 1.2.0

== INSTALL:

  $ sudo gem install raingrams

== EXAMPLES:

* Train a model with ycombinator comments:

    require 'raingrams'
    require 'nokogiri'
    require 'open-uri'
    
    include Raingrams
    
    model = BigramModel.build do |model|
      doc = Nokogiri::HTML(open('http://news.ycombinator.org/newcomments'))
      doc.search('span.comment') do |span|
        model.train_with_text(span.inner_text)
      end
    end

* Update a trained model:

    model.train_with_text %{Interesting videos. Anders talks about
      functional support on .net, concurrency, immutability. Guy Steele
      talks about Fortress on JVM. Too bad they are afraid of macros
      (access to AST), though Steele does say Fortress has some support.}
    
    model.refresh

* Generate a random sentence:

    model.random_sentence
    # => "OTOOH if you use slicehost even offer to bash Apple makes it will
    exit and its 38 month ago based configuration of little networks
    created."

* Dump a model to a file, to be marshaled later:

    model.save('path/for/model')

* Load a model from a file:

    Model.open('path/for/model')

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
