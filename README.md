# JGivenGherkin

This little awk script creates the initial JGiven setup from a Gherkin file.

## Supported

- Scenario
- Given, When, Then, And
- String, Integer, Float variables

## Limitations

### Variables

- English language only.
- Only one variable per line.
- The string variable has to be the last element in the line.

## Example

A simple Gherkin file:

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

The generated Java test:

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
