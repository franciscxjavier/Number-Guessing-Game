#!/bin/bash

# Connect to the database as the "freecodecamp" user and use the "number_guess" database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt the user for their username
echo "Enter your username:"
read USERNAME

# Check if the user already exists in the database
USERNAME_AVAIL=$($PSQL "SELECT player_name FROM game a, player b WHERE a.player_id=b.player_id AND player_name='$USERNAME' GROUP BY player_name;")
GAMES_PLAYED=$($PSQL "SELECT COUNT(a.player_id) FROM game a, player b WHERE a.player_id=b.player_id AND player_name='$USERNAME';")
BEST_GAME=$($PSQL "SELECT MIN(no_tries) FROM game a, player b WHERE a.player_id=b.player_id AND player_name='$USERNAME';")

# If the user does not exist, insert them into the database
if [[ -z $USERNAME_AVAIL ]]
then
    INSERT_USERNAME=$($PSQL "INSERT INTO player(player_name) VALUES('$USERNAME');")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
# If the user does exist, display their statistics
else
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate a random number between 1 and 1000
RANDOM_NUM=$((1 + $RANDOM % 1000))

# Start the number guessing game
    # Prompt the user to guess the secret number
    echo "Guess the secret number between 1 and 1000:"

    # Initialize the number of guesses to 0
    guesses=0

# Keep prompting the user to guess until they guess the secret number
while [[ $guessed_number -ne $RANDOM_NUM ]]
do
    # Increment the number of guesses
    guesses=$((guesses+1))

    # Read the user's guess
    read guessed_number

    if [[ ! $guessed_number =~ ^[0-9]+$ ]]
    then
        echo "That is not an integer, guess again:"
    # If the user's guess is too high, ask them to guess again
    elif [[ $guessed_number -gt $RANDOM_NUM ]]
    then
        echo "It's lower than that, guess again:"
    # If the user's guess is too low, ask them to guess again
    elif [[ $guessed_number -lt $RANDOM_NUM ]]
    then
        echo "It's higher than that, guess again:"
    else 
        # If the user's guess is correct, congratulate them and display the number of guesses it took
        echo "You guessed it in $guesses tries. The secret number was $RANDOM_NUM. Nice job!."
    fi

done

# Insert the player's game into the database
insert_player=$($PSQL "INSERT INTO game(player_id, no_tries) VALUES((SELECT player_id FROM player WHERE player_name='$USERNAME'), $guesses);")

exit 0
