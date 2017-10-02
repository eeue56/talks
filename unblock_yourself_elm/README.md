title: How to unblock yourself with Elm
author:
  name: Noah (eeue56)
  url: https://github.com/eeue56
  twitter: eeue56
output: basic.html
style: style.css
override: true
controls: false

-- title_page


# How to unblock yourself with Elm

<script src="regex.js"> </script>
<script src="regex_example.js"> </script>
<img class="front-profile-pic" onclick="toggleFullScreen();" src="./images/profile.png"></img>


--

## Personal motto

</br></br></br>

If it makes sense to do it in Elm, we _can_ do it in Elm.

--

## What blocks us?

- Upstream issues

- Unfamiliarity with modelling

- Fear of committing


-- blocks

<!-- Blocks -->
<!-- In your dream application, everything fits together perfectly. Every piece looks the same and exposes a common API -->

-- reality

<!-- Reality -->
<!-- In reality, we usually don't get that. Instead, we get bits and pieces that kinda fit togehter. But it works! The features our product owners ask for are there, our users can use the site --> 

-- rubble

<!-- Rubble -->
<!-- When it comes to Elm, there's a fixed idea of what a brick should look like for the core libraries. There might be pieces of your old application, sitting next to Elm. We like to keep our Elm seperate from the rest of our code, interacting only at the edges -->
  
-- brick_making

<!-- brick making -->
<!-- Here's a question: what makes a good brick? How do we make something that fits into our Elm code, that behaves like our Elm code? -->

--

## Ask yourself 

- What are we trying to do?

- What are the important features?

- Can we write an example?

<!-- We can start by asking ourselves these three questions -->

--

## Answer yourself

- Regex search for a text editor

- Take regexes from the user

- Show error when we have an invalid regex

- Show different error when nothing matches

- Show results when regex matches

--

## First pass example

```haskell
type alias Model = 
  { regex : Regex
  , isValidRegex : Bool
  }

updateRegex : String -> Model -> Model
updateRegex possibleRegex model = 
  { model 
  | regex = Regex.regex possibleRegex
  , isValidRegex = isValidRegex possibleRegex
  }

isValidRegex : String -> Bool
isValidRegex = ...



```

<!-- So our model might look something like this. One field for the regex itself, and another to say if it's valid or not
Note that at this point, we don't care about how we implement `isValidRegex`. We only care about how we use it. But this example has some flaws. We shouldn't always have a Regex - it should only be there if it's valid. -->

--

## Cover more states

```haskell
type alias Model = 
  { regex : Maybe Regex
  , isValidRegex : Bool
  }

updateRegex : String -> Model -> Model
updateRegex possibleRegex model = 
  let 
    usableRegex = 
      isValidRegex possibleRegex
  in 
    { model 
    | regex = 
      if usableRegex then 
        Regex.regex possibleRegex
          |> Just 
      else 
        Nothing
    , isValidRegex = 
      usableRegex
    }

```

<!-- The next step we can take is to make our regex a maybe. If it's valid, then the regex is `Just Regex`. Otherwise, it's `Nothing`. This lets us deal with more states without adding more attributes.  -->

--

## De-duplicate fields

```haskell
type alias Model = 
  { regex : Maybe Regex
  }

updateRegex : String -> Model -> Model
updateRegex possibleRegex model = 
  let 
    usableRegex = 
      isValidRegex possibleRegex
  in 
    { model 
    | regex = 
      if usableRegex then 
        Regex.regex possibleRegex
          |> Just 
      else 
        Nothing
    }
```

<!-- And then we realise, hey, maybe represents two states! Booleans represent two states! And we can just get rid of the boolean entirely.
At this point, our code is looking pretty reasonable! Until we remember one requirement from our spec, that is -->

--
# We aren't representing all states



-- no_matches

-- matches
  
-- regex_error


<!-- We're missing the "why was this regex invalid state". We have no way of getting the parsing error back from the regex! -->

-- 
## Cover more states

```haskell


type alias Model = 
  { regex : Result String (Maybe Regex)
  }

validateRegex : String -> Result String (Maybe Regex)
validateRegex possibleRegex model = ...

updateRegex : String -> Model -> Model
updateRegex possibleRegex model = 
  { model | regex = validateRegex possibleRegex }

```

<!-- Let's take another approach. Instead of having a function that returns a boolean, we instead return a result. This allows us to capture the error message from when we try to create the regex! This API now looks pretty good, and the boilerplate required in our update function is minimal. -->

--

## But wait..


- There is no function in Elm's core libraries for validating regexes



<!-- Now we know what we _want_ the code to look like, we can try to implement it. 
Here's where we hit our first big blocker.
There is no function in Elm's core libraries that gives you the ability to check if a regex is valid or not
In fact, if you pass an invalid regex to Elm at runtime, you'll get a runtime error, causing your application to crash -->

--

## What breaks?

```haskell
update (NewRegex rawRegex) model =
    let
        newRegex = Regex.regex rawRegex
    in
        ( rawRegex, Cmd.none )
```

<button onclick="enableError();">Enable errors</button>
<button onclick="toggleFullScreen();">Toggle fullscreen</button>
<button onclick="window.location.reload()">Reload</button>

<span id="bad-regex-example"></span>
<script>
  var badRegexElm = Elm.BadRegexExample.embed(document.getElementById("bad-regex-example"));
</script>


--

# Elm won't work for this problem

<!-- I can't use Elm! I'm going to have to use Javascript instead, and replace this whole piece. -->

--

# But I want to use Elm..

<!-- I can't use Elm! I'm going to have to use Javascript instead, and replace this whole piece. -->

-- 

## Use the community

- Elm Slack
- Reddit
- Elm-discuss

--

## You'll be asked

- What are you trying to do?

- What are the important features?

- Can you write an example?

<!-- And when you come to these places, they'll ask you these three questions. Luckily, you've already answered them, and you know exactly where you got stuck-->

--

## A bad way to ask

<div class="bad-question" id="question-padding">Making an invalid regex breaks my app and now I can't work!</div>

--

## A good way to ask

<div class="good-question">I'm trying to make a regex search for an editor. </br></br>
I'd like to display the error if the regex is invalid. </br></br> However, when I use this code <code>...</code>, I get a runtime error.</div>

--

```haskell

port checkIfValidRegex : String -> Cmd msg

port isValidRegex : ((String, Bool) -> msg) -> Sub msg

```

```javascript

var isValidRegex = function(regex){
  try {
    var _ = new RegExp(regex);
    return [ regex, true ];
  } catch (e)
    return [ regex, false ];
  }
}
```
<!-- The will probably suggest to you that  -->
-- stone

<!-- stone -->

-- brick

<!-- brick -->

--

## New ports
```haskell

port checkIfValidRegex : String -> Cmd msg

port isValidRegex : ((String, Bool) -> msg) -> Sub msg


```

</br>

## Original model

```
type alias Model = 
  { regex : Regex
  , isValidRegex : Bool
  }
```

-- 

```haskell

## Original "best solution"

type alias Model = 
  { regex : Result String Regex
  }

validateRegex : String -> Result String Regex
validateRegex possibleRegex model = ...


## Ports "best solution"


port checkIfValidRegex : String -> Cmd msg
port isValidRegex : (Result String String -> msg) -> Sub msg

```

--

```javascript
var isValidRegex = function(regex){
  try {
    var _ = new RegExp(regex);
    return { "Ok" : regex };
  } catch (e) {
    return { "Err": e.message };
  }
}
```

<!-- Now we have something that looks a little friendlier! --> 
--

```haskell

decodeRegex : Decoder (Result String String)
decodeRegex =
    Json.Decode.oneOf
        [ Json.Decode.field "Ok" Json.Decode.string
            |> Json.Decode.map Ok
        , Json.Decode.field "Err" Json.Decode.string
            |> Json.Decode.map Err
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ decodeValue decodeRegex 
            >> Result.map IsValidRegex 
            >> Result.withDefault NoOp
            |> isValidRegex
        ]

```


--

<span id="regex-elm-host"/>
<script>
  var regexElm = Elm.RegexExample.embed(document.getElementById("regex-elm-host"));
  regexElm.ports.checkIfValidRegex.subscribe(function(regex){
    regexElm.ports.isValidRegex.send(isValidRegex(regex));
  });

</script>



--

## What we did

- Identified what we wanted to do

- Created examples

- Found the API that would cover all edge cases

- When we got stuck, consluted the community

- Implemented a working solution

- Refactored to better fit our original API

--

## An open statement

- Join the Elm Slack

- All questions are answered

--


<img class="profile-pic" src="./images/profile.png"></img>

## 

<strong>Noah Hall</strong>

</br>

</br>

</br>



<em>@eeue56</em>
<button onclick="toggleFullScreen();">Toggle fullscreen</button>