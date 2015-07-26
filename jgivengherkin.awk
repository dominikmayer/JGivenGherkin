#!/bin/sh
arbitrary_long_name==0 "exec" "/usr/bin/env" "gawk" "-f" "$0" "$@"

BEGIN {
  INDENTATION = "    ";
  prev = "";
  output = "";
  allowPreviousAppending = 0;
  prevVariable = "";
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

function process_line(beginning, previousEnding, allowAppending) {
  extract_string_variables();
  extract_float_variables(); # must stand first
  extract_int_variables();

  convert_to_snake_case();

  if (allowPreviousAppending) {
    output = prev previousEnding;
  } else {
    output = prev
  }
  prev = beginning $0"(" prevVariable ")";
  allowPreviousAppending = allowAppending;
  prevVariable = "";
}

function extract_string_variables() {
  if (match($0, /"/)) {
    number = split($0, variables, "\"");
    prevVariable = "\"" variables[2] "\"";
    sub(/".*?"/, "")
  }
}

function extract_float_variables() {
  if (match($0, /[0-9*]\.[0-9*]/, variables)) {
    prevVariable = variables[0];
    sub(/[0-9*]\.[0-9*]/, "$");
  }
}

function extract_int_variables() {
  if (match($0, /[0-9*]/, variables)) {
    prevVariable = variables[0];
    sub(/[0-9*]/, "$");
  }
}

function convert_to_snake_case() {
  remove_keyword();
  gsub(/ /, "_");
}

function convert_to_camel_case() {
  remove_keyword();
  capitalize();
  gsub(/ /, "");
}

function capitalize() {
  for (i=1; i<=NF; ++i) {
    $i=toupper(substr($i,1,1)) tolower(substr($i,2));
  }
}

/^feature: / {
  convert_to_camel_case()
  print "import org.junit.Test;";
  print "import com.tngtech.jgiven.junit.ScenarioTest;\n";
  print "public class " $0 "Test extends";
  print INDENTATION "ScenarioTest<GivenSomeState, WhenSomeAction, ThenSomeOutcome> {\n";
}

/^scenario: / {
    print INDENTATION "@Test"
    process_line("public void ", "", 0);
    prev = prev " {\n"
}

/^(given|when|then)/ {
  process_line(INDENTATION $1"().", ";\n", 1)
}

/^and/ {
  process_line(INDENTATION INDENTATION $1"().", ".", 1)
}

#/[^0-9]*/ {print $2,$3}

{ if (output != "") {
    print INDENTATION output
  }
}

END {
  print INDENTATION prev ";"
  print INDENTATION "}"
  print "}"
}
