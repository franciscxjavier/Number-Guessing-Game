#!/bin/bash

# Generamos un número aleatorio entre 1 y 1000
numero_secreto=$(shuf -i 1-1000 -n 1)

# Inicializamos la variable de contador de intentos en 0
intentos=0

# Pedimos al usuario que adivine el número
echo "Guess the secret number between 1 and 1000:"
read numero_adivinado

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
