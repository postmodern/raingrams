=== 0.1.2 / 2009-04-23

* Require nokogiri >= 1.2.0.
* No longer require hpricot.
* Added missing 'lib/raingrams/tokens/tokens.rb' file to the Manifest.
* Added Raingrams::Helpers:
  * Moved text commonality calculating methods into
    Raingrams::Helpers::Commonality.
  * Moved text frequency calculating methods into
    Raingrams::Helpers::Frequency.
  * Moved text probability calculating methods into
    Raingrams::Helpers::Probability.
  * Moved random text generating methods into
    Raingrams::Helpers::Random.
  * Moved text similarity calculating methods into
    Raingrams::Helpers::Similarity.
* Added Model#to_hash.
* Capitalize randomly generated sentences if case is ignored.

=== 0.1.1 / 2008-10-12

* Improved the parsing abilities of Model#parse_sentence and
  Model#parse_text.
* Fixed a bug in Model#has_ngram?.
* Fixed a bug in Model#ngrams_starting_with.
* Removed Model#probability_of_gram, for now atleast.
* Renamed Ngram#includes? to Ngram#includes_all?.
* Renamed Model#ngrams_including to Model#ngrams_including_all.
* Renamed Model#frequencies_of_ngrams to Model#frequency_of_ngrams.
* Added the following methods:
  * Ngram#includs_any?.
  * Model.open.
  * Model.train_with_paragraph.
  * Model.train_with_text.
  * Model.train_with_file.
  * Model.train_with_url.
  * Model#has_gram.
  * Model#ngrams_including_all.
  * Model#ngrams_from_paragraph.
  * Model#train_with_paragraph.
  * Model#train_with_file.
  * Model#train_with_url.
  * Model#frequency_of_ngram.
  * Model#frequencies_for.
  * Model#frequencies_of_ngrams.
  * Model#save.

=== 0.1.0 / 2008-10-06

* Various bug fixes.
* Added NgramSet and ProbabilityTable classes.
* Merged NgramModel with the Model class.
* Refactored the Model class.
* Added random_gram_sentence, random_sentence, random_paragraph and
  random_text methods to the Model class.

=== 0.0.9 / 2008-01-09

* Initial release.
* Supports all non-zero ngram sizes.
* Supports text and non-text grams.
* Supports Open and Closed vocabulary models.

