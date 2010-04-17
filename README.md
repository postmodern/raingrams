# Raingrams

* [raingrams.rubyforge.org](http://raingrams.rubyforge.org/)
* [github.com/postmodern/raingrams](http://github.com/postmodern/raingrams/)
* Postmodern (postmodern.mod3 at gmail.com)

## DESCRIPTION:
  
Raingrams is a flexible and general-purpose ngrams library written in Ruby.
Raingrams supports ngram sizes greater than 1, text/non-text grams, multiple
parsing styles and open/closed vocabulary models.

## FEATURES:
  
* Supports ngram sizes greater than 1.
* Supports text and non-text grams.
* Supports Open and Closed vocabulary models.
* Supports calculating the similarity and commonality of sample text against
  specified models.
* Supports generating random text from models.

## REQUIREMENTS:

* [nokogiri](http://nokogiri.rubyforge.org/) >= 1.2.0

## INSTALL:

    $ sudo gem install raingrams

## EXAMPLES:

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

## LICENSE:

See {file:LICENSE.txt} for license information.

