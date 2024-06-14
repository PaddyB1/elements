if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number = $1;")
else
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol = '$1' or name = '$1';")
fi

if [[ -z $ATOMIC_NUMBER ]]
then 
  echo "I could not find that element in the database."
  exit
fi

NAME=$($PSQL "select name from elements where atomic_number = $ATOMIC_NUMBER;")
SYMBOL=$($PSQL "select symbol from elements where atomic_number = $ATOMIC_NUMBER;")
MASS=$($PSQL "select atomic_mass from properties where atomic_number = $ATOMIC_NUMBER;")
MELT=$($PSQL "select melting_point_celsius from properties where atomic_number = $ATOMIC_NUMBER;")
BOIL=$($PSQL "select boiling_point_celsius from properties where atomic_number = $ATOMIC_NUMBER;")
TYPE=$($PSQL "select type from properties inner join types on properties.type_id = types.type_id where atomic_number = $ATOMIC_NUMBER;")

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."