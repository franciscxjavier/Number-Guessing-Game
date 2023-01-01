#!/bin/bash
#Iniciamos variable de SQL
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#Pedimos el nombre de usuario
echo "Enter your username:"
read USERNAME

#Consultamos si existe el usuario
PLAYER_EXISTS_QUERY=$($PSQL "select player_name from game a, player b where a.player_id=b.player_id and player_name='$USERNAME' group by player_name;")

#Si no existe, se inserta el usuario
if [[ -z $PLAYER_EXISTS_QUERY ]]
then
	echo Welcome, $username! It looks like this is your first time here.
	username_insert=$($PSQL "INSERT INTO player(player_name) VALUES('$username');")
#Si existe, se obtienen sus detalles
else
	TOTAL_GAMES=$($PSQL "select count(a.player_id) from game a, player b where a.player_id=b.player_id and player_name='$USERNAME';")
	LEAST_TRIES=$($PSQL "select min(no_tries) from game a, player b where a.player_id=b.player_id and player_name='$USERNAME';")
	echo Welcome back, $USERNAME! You have played $TOTAL_GAMES games, and your best game took $LEAST_TRIES guesses.
fi

# Generamos un número aleatorio entre 1 y 1000
numero_secreto=$(shuf -i 1-1000 -n 1)

# Inicializamos la variable de contador de intentos en 0
intentos=0

# Pedimos al usuario que adivine el número
echo "Guess the secret number between 1 and 1000:"
read numero_adivinado

while [[ ! $numero_adivinado =~ ^[0-9]+$ ]]
do
echo "That is not an integer, guess again:"
read numbero_adivinado
done

# Mientras el número adivinado sea diferente al número secreto, seguimos pidiendo al usuario que adivine
while [[ $numero_adivinado -ne $numero_secreto ]]
do
    # Incrementamos el contador de intentos
    intentos=$((intentos+1))

    # Si el número adivinado es mayor que el número secreto, decimos al usuario que adivine un número más bajo
    if [[ $numero_adivinado -gt $numero_secreto ]]
    then
        echo "It's lower than that, guess again:"
    # Si el número adivinado es menor que el número secreto, decimos al usuario que adivine un número más alto
    else
        echo "It's higher than that, guess again:"
    fi
    read numero_adivinado
done

# Si el número adivinado es igual al número secreto, decimos al usuario que ha acertado y mostramos cuántos intentos pasaron
echo "You guessed it in $intentos tries. The secret number was $numero_secreto. Nice job!."
exit 0
