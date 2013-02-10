# A hash to hold the URLs used in this example.  In reality this data would
# probably be provided by a database or external file, but for the purposes of
# this exercise an initializer works just fine.

URLS = {
  url: [
    'http://apple.com',
    'https://apple.com',
    'https://www.apple.com',
    'http://developer.apple.com',
    'http://en.wikipedia.org',
    'http://opensource.org'
  ],
  referrer: [
    'http://apple.com',
    'https://apple.com',
    'https://www.apple.com',
    'http://developer.apple.com',
    nil
  ]
}.freeze