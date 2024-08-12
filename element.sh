PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

SHOW_INFO() {
  IFS='|'
  echo "$1" | while read BAR ATOMIC_NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
  IFS=$' \t\n'
}

NOT_FOUND_ELEMENT_CHECK() {
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    SHOW_INFO $1
  fi
}

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9]+ ]]
  then
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
    NOT_FOUND_ELEMENT_CHECK $DATA
  elif [[ ! ${#1} -gt 2 ]]
  then
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
    NOT_FOUND_ELEMENT_CHECK $DATA
  else
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
    NOT_FOUND_ELEMENT_CHECK $DATA
  fi
fi
