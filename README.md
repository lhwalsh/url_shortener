# README

This is a Rails api only application to shorten URLs.

To shorten a url, make a request to the `sites/encode` endpoint with a `url` parameter.

* The url is a required param that will return an error if not given.
* The encode algorithm will create a new site model that stores the original url. If the url has been submitted before, it will use the existing site model instead of creating a new model.
* After it has found/created the site model, it will convert the ID of that model to a base 62 string with only lower/upper case letters and numbers.
* The algorithm to encode the ID requires an array with the 62 valid characters. It will find the values of the new encoded url by taking the modulus of the ID by 62 and looking up the corresponding character for that index. It then divides the ID by 62 and continues this process until the ID is less than 62. After taking the final modulus it will combine all the characters to form the new encoded url.
* All encoded urls are prepended with `http://short.est/` because I saw it in the example and it looked nice.

To get the original url back, make a request to the `sites/decode` endpoint with a `url` parameter of the encoded url.

* The url is a required param that will return an error if not given.
* The decode algorithm will return a 400 error with a custom message if the provided url does not start with `http://short.est/` in order to verify that it originally came from the site.
* The algorithm to decode the ID requires an array with the 62 valid characters. It will remove the base url, reverse the resulting string and loop through each character. For each character it will find its corresponding index in the list of valid characters and add that to a running sum. For each new addition to the sum, it will multiply the sum by 62 before adding the next index.
* After decoding it will try to find the Site by the decoded ID and render the original url stored for that site.
* If no Site is found for the decoded id, it will return a 400 error with a custom message clarifying that the encoded url must come from this application.
