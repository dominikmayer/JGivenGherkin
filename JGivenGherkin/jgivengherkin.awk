#!/usr/bin/awk -f
BEGIN {
  INDENTATION="    "
  prev = ""
  output = ""
  #setPrev = false
}

# We convert everything to lowercase so we don't have to worry about case in the Gherkin files.
# We also remove the trailing whitespace from all lines.

{ $0 = tolower($0);
  remove_trailing_whitespace()
}

function remove_keyword() {
  $1 = ""
  remove_trailing_whitespace()
}

function remove_trailing_whitespace() {
  sub(/^[ \t]+/, "")
}

function convert_to_snake_case(beginning, ending) {
  remove_keyword();
  gsub(/ /, "_");
  output = prev ending;
  prev = beginning $0"()";
  #setPrev = true;
}

# Now we convert the scenario to a JGiven method.

/^scenario: / {
    print "@Test"
    convert_to_snake_case("public void ", "");
}

/^(given|when|then)/ {
  convert_to_snake_case(INDENTATION $1"().", ";\n")
}

/^and/ {
  convert_to_snake_case(INDENTATION INDENTATION $1"().", ".")
}

{ #if (setPrev == false) {prev = ""}
  #if (prev != output) {print output}
  #print "Prev: " prev
  #print "Output: " output
}

END {
  print prev ";"
  print "}"
}
