# Development Log

This a log of things challenges I faced and (hopefully by the time you're reading this) overcame.

## 3rd September 2019

### Changing the database from a hash to an array

With the terminal app, I planned on having users store their decks in a JSON file. Each deck would be a hash which had the key "title" and the value being the deck title, and the key "cards" which had the value being an array of cards. Each card would be a hash with a "question" key and an "answer" key. I initially stored all the decks in a hash, with each deck having a key of the title. I soon ran into problems when it came to iterating through the decks and listing them on the screen for users to edit or review. It would be more practical to have the decks in an ordered list (array) instead, as I would then be able to access the index much easier, and use user input to access the decks far easier.

## 4th September 2019

### Implementing deck review and subsequent reviews of failed cards

Today I implemented the basic review functionality that makes the flashcard app function. Users are able to cycle through flashcards in a deck and are able to skip cards, answer correctly or answer incorrectly. These incorrectly answered cards are placed in another deck which is then reviewed after the main deck has finished. I was able to implement the "subsequent review of incorrect cards" function by using recursion instead of continuing on with another control flow path or calling another function, which I thought was pretty nifty. I used default arguments in the start_review for the first review, which took in a deck of flashcards and a boolean to denote whether or not this was the first review. The default arguments were the initial full deck, and true. I also kept an empty array for the incorrect cards to be pushed into. At the end of the main deck review, the start_review function is called recursively with the deck of incorrect cards passed as the first argument, and false as the second, allowing the user to continuously review until they get all cards right. The second argument that checks whether the review is the initial review or not is to keep count of score, which is presented in a statistics screen at the completion of review. When a card is correctly guessed, it only updates the score count if the initial review boolean is true. This stops the score from updating when the user correctly guesses cards in subsequent reviews.
