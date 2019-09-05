# Flashcard App

Flashcard App is a terminal app written in Ruby and is the first assessment of the Coder Academy Bootcamp Fast Track course. A link to the repository can be found here at [https://github.com/rmar8138/flashcard-app](https://github.com/rmar8138/flashcard-app).

## Statement of Purpose and Scope

Flashcard App is an application that allows users to create flashcards for review. Users can sort these cards into decks that have titles for easy review. Users can review these decks to practice or study on a topic they are working on. Decks and cards themselves can be edited by the users. Users can change settings to allow for different reviews (timed reviews etc).

Flashcards are a great way for people to review a topic that they are struggling on. However, they may be cumbersome to make physically, and while flashcards are portable, they can be prone to damage or being lost. Users can use this app straight from their terminal to easily review any subject they wish. While there are already fully fledged flashcards apps readily available, users can enjoy a no frills simple flashcard experience through this app.

This app can be a great resource for anyone wishing to brush up on a topic they are learning. Developers who enjoy working with the command line can now create and review their own flashcard decks straight from the comfort of their own command line!

## Features

- Create, Update, Edit and Delete Decks/Cards  
  Users are able to perform basic CRUD operations on decks and individual flashcards. User input is received and case statements and if/else statements are used to direct control flow. These decks are saved in a hash and stored locally in a JSON file.

- Review Decks  
  Users are able to review flashcards in a deck. Users can skip cards or answer whether they got the card right or wrong. Wrong cards sent to another array and recursion is used to repeatedly review until the user gets all cards correct. Users can also enter the --review flag when running the program followed by the name of a deck as an argument in order to have a quick review session without running the app completely.

- Change Settings
  Users are able to configure different features to tweak how they would like their reviews to run. This is still udner construction and will be updated soon!

## User Interaction and Experience

Users are greeted with a welcome screen which allows them to select from a menu of options. These are:

1. Review
2. Add Deck
3. Edit Deck
4. Settings
5. Exit

##### Review

Users can select from their decks to review. Once a deck is selected, users enter a 'review'. In the review, the cards in the deck are shuffled and shown to the user one by one. The user can choose to show the answer, or skip the card, which will move the card to the end of the pile. Upon showing the answer, the user can select whether they were correct or incorrect. If correct, a running score is updated and the next card is showing. If incorrect, the card is removed from the current review and is placed to another deck for a subsequent review afterwards. These subsequent reviews are repeated until there are no incorrect cards left. A statistics screen is shown at the end of the whole review.

##### Add Deck

Users are able to create their own decks, and are prompted for a deck title. They can then create as many cards as they want.

##### Edit Deck

Users can view all of their decks and can either add extra cards, edit existing cards, delete cards, edit the deck title or delete the entire deck.

##### Settings

Users can change settings to alter the way reviews are structured. Under construction!

## Control Flow Diagram

Control Flow diagram of the app as of the latest commit can be found [here](./docs/flashcard-app-flowchart.pdf).

## Implementation Plan

Trello was used to keep track of feature and documentation backlog. When features where being implemented, feature cards would be placed in the 'In Progress' list. When they were finished, they would be moved to the 'Testing' list to be manually tested. Once manually tested, they moved to the 'Completed' list.

![Trello Board](./docs/flashcard-app-trello.png)

## Manual Testing

Manual testing was implemented as the app was being developed, and tested features were tracked on a separate spreadsheet. A screenshot of this can be seen below.

![Manual testing spreadsheet](./docs/flashcard-app-manual-test.png)

## Development Log

Development log can be viewed [here](./development-log.md).

## Help

Flashcard App relies on a few gems to run:

- TTY Prompt
- TTY Font
- TTY Table
- TTY Box

```
gem install tty-prompt
gem install tty-font
gem install tty-table
gem install tty-box
```

There is an executable called move_to_dist that can be run to move all application files to a dist folder for future distribution.
