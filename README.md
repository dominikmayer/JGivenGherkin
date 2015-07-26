# JGivenGherkin

This little awk script creates the initial JGiven setup from a Gherkin file.

## Install

1. Install `gawk`.

2. Download `jgivengherkin.awk` and make it executable:

        $ chmod +x jgivengherkin.awk

## Run

By default JGivenGherkin outputs the text to the console:

    ./jgivengherkin.awk my_test.gherkin

To save it use this command:

    ./jgivengherkin.awk my_test.gherkin > my_test.java

## Configuration

By default JGivenGherkin uses four spaces to indent. You can change this by opening and editing the following line:

    INDENTATION = "    ";

## Supported

- Scenario
- Given, When, Then, And
- String, Integer, Float variables

## Limitations

- English language only.
- Only features with one scenario are properly supported.
- Only one variable per line.
- The string variable has to be the last element in the line.

## Example

A simple Gherkin file:

```gherkin
Feature: We want to cook our meal
  We do this because we are really, really hungry.

Scenario: A pancake can be fried out of an egg milk and flour

  Given an egg
    And some milk
    and the ingredients "flour"
    and 3 teaspoons of salt
    and sugar for 1.5 Euro
   When the cook mangles everything to a dough
    And the cook fries the dough in a pan
   Then the resulting meal is a pan cake
```

The generated Java test:

```java
import org.junit.Test;
import com.tngtech.jgiven.junit.ScenarioTest;

public class WeWantToCookOurMealTest extends
    ScenarioTest<GivenSomeState, WhenSomeAction, ThenSomeOutcome> {

    @Test
    public void a_pancake_can_be_fried_out_of_an_egg_milk_and_flour() {

        given().an_egg().
            and().some_milk().
            and().the_ingredients("flour").
            and().$_teaspoons_of_salt(3).
            and().sugar_for_$_euro(1.5);

        when().the_cook_mangles_everything_to_a_dough().
            and().the_cook_fries_the_dough_in_a_pan();

        then().the_resulting_meal_is_a_pan_cake();
    }
}
```
