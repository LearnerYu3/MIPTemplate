#/bin/bash

for ((i = 1; i <= 40; i++))
do
   wget http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/pmed${i}.txt
done

rename -v "s/txt/pmed/" pmed*.txt
