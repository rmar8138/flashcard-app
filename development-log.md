# Development Log

This a log of things challenges I faced and (hopefully by the time you're reading this) overcame.

## 3rd September 2019

### Changing the database from a hash to an array

With the terminal app, I planned on having users store their decks in a JSON file. Each deck would be a hash which had the key "title" and the value being the deck title, and the key "cards" which had the value being an array of cards. Each card would be a hash with a "question" key and an "answer" key. I initially stored all the decks in a hash, with each deck having a key of the title. I soon ran into problems when it came to iterating through the decks and listing them on the screen for users to edit or review. It would be more practical to have the decks in an ordered list (array) instead, as I would then be able to access the index much easier, and use user input to access the decks far easier.
