# Giact

If you have to use the Giact recurring eCheck POST API my heart goes out to you. Here's a Ruby wrapper to ease your burden.

## Installation

    sudo gem install giact
    
## TODO

API calls left to implement:

* list installment checks by order ID
* list installment checks by transaction ID
* cancel future installment checks by order ID
* cancel future installment checks by transaction ID
* cancel a transaction by order ID that has not been batched
* cancel a transaction by transaction ID that has not been batched
* request a refund by order ID
* request a refund by transaction ID
* request a partial refund by order ID
* request a partial refund by transaction ID
* return a daily summary
* list daily deposits for a given date
* list checks returned for a given date
* list checks refunded for a given date
* list transactions scrubbed for a given date
* list errored transactions for a given date
* list checks returned for a given date range
* list checks refunded for a given date range

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 [Wynn Netherland](http://wynnnetherland.com). See LICENSE for details.
