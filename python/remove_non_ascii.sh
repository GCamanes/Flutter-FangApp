LC_ALL=C tr -dc '\0-\177' <$1 >tmp.txt && mv tmp.txt $1