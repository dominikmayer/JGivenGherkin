#!/usr/bin/awk -f
BEGIN {
  INDENTATION="    "
  prev = ""
  output = ""
  allowPreviousAppending = 0
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

function convert_to_snake_case(beginning, previousEnding, allowAppending) {
  remove_keyword();
  gsub(/ /, "_");
  if (allowPreviousAppending) {
    output = prev previousEnding;
  } else {
    output = prev
  }
  prev = beginning $0"()";
  allowPreviousAppending = allowAppending;
}

# Now we convert the scenario to a JGiven method.

/^scenario: / {
    print "@Test"
    convert_to_snake_case("public void ", "", 0);
    prev = prev " {\n"
}

/^(given|when|then)/ {
  convert_to_snake_case(INDENTATION $1"().", ";\n", 1)
}

/^and/ {
  convert_to_snake_case(INDENTATION INDENTATION $1"().", ".", 1)
}

{ if (output != "") {
    print output
  }
}

END {
  print prev ";"
  print "}"
}