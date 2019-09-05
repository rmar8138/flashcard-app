# Flashcard App

Flashcard App is a terminal app written in Ruby and is the first assessment of the Coder Academy Bootcamp Fast Track course.

## Statement of Purpose and Scope

Flashcard App is an application that builds decks of flashcards for users to use for study and review. Users create decks and fill them with cards, like any standard flashcard deck. These cards have a front and a back; the front holding the question and the back holding the answer. This will allow users to review any topic they wish straight from their command line!

## Features

## User Interaction and Experience

## Development Log

This a log of things challenges I faced and (hopefully by the time you're reading this) overcame.

### 3rd September 2019

#### Changing the database from a hash to an array

With the terminal app, I planned on having users store their decks in a JSON file. Each deck would be a hash which had the key "title" and the value being the deck title, and the key "cards" which had the value being an array of cards. Each card would be a hash with a "question" key and an "answer" key. I initially stored all the decks in a hash, with each deck having a key of the title. I soon ran into problems when it came to iterating through the decks and listing them on the screen for users to edit or review. It would be more practical to have the decks in an ordered list (array) instead, as I would then be able to access the index much easier, and use user input to access the decks far easier.

### 4th September 2019

#### Implementing deck review and subsequent reviews of failed cards

Today I implemented the basic review functionality that makes the flashcard app function. Users are able to cycle through flashcards in a deck and are able to skip cards, answer correctly or answer incorrectly. These incorrectly answered cards are placed in another deck which is then reviewed after the main deck has finished. I was able to implement the "subsequent review of incorrect cards" function by using recursion instead of continuing on with another control flow path or calling another function, which I thought was pretty nifty. I used default arguments in the start_review for the first review, which took in a deck of flashcards and a boolean to denote whether or not this was the first review. The default arguments were the initial full deck, and true. I also kept an empty array for the incorrect cards to be pushed into. At the end of the main deck review, the start_review function is called recursively with the deck of incorrect cards passed as the first argument, and false as the second, allowing the user to continuously review until they get all cards right. The second argument that checks whether the review is the initial review or not is to keep count of score, which is presented in a statistics screen at the completion of review. When a card is correctly guessed, it only updates the score count if the initial review boolean is true. This stops the score from updating when the user correctly guesses cards in subsequent reviews.

### 5th September 2019

#### Deleting multiple elements from an array at once based on index

I discovered a really cool gem called TTY Prompt (and there's actually a whole family of TTY gems that focus on improving user experience and graphics in terminal apps) which allowed me to display options and have users select with arrow keys. I decided to refactor my whole codebase to add this feature, as till this point I had just been collection user input with gets and using case statements to redirect control flow. This gem would make the user interface much cleaner, improve user experience and lessen the amount of code. Refactor went quite smoothly but I ran into one slight road block when it came to deleting cards. Before implementing tty-prompt, when a user wanted to delete a card I would display all cards and have the corresponding number to the left. I would get the user to input the number of the card they wished to delete, and then ran that through and instance method on the Deck class that took an index and called delete_at on the cards array. However, tty-prompt comes with a really cool multi_select feature which allows you to select multiple options, and returns an array. In order to implement this, I changed the existing delete_card instance function on the Deck class to cycle through the array of indexes collected when the user used the multi_select feature, and in turn call delete_at with each index passed. However this did not work as expected, and started deleting seemingly random cards instead, and as well as crashing when trying to delete a card that was the only card in the deck. I realised that when the delete_at method is called with the index passed, it deleted the correct index but every single element after the deleted one shifted up one index, and would throw everything off. After some googling and stack overflow, I found a method called reject which is like the opposite of filter, it rejects elements from the new array based on a conditional. I used the include? method to test if the current card index was included in the list of indexes that the user chose to delete, and this ended up working.

## Help
