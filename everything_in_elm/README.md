title: Everything in Elm
author:
  name: Noah (eeue56)
  url: https://github.com/eeue56
  twitter: eeue56
output: basic.html
style: style.css
override: true
controls: false

-- title_page


# Everything in Elm

<script src="regex.js"> </script>
<script src="regex_example.js"> </script>
<img class="front-profile-pic" onclick="toggleFullScreen();" src="./images/profile.png"></img>


-- title_page


# Everything in Elm..?

<script src="regex.js"> </script>
<script src="regex_example.js"> </script>
<img class="front-profile-pic" onclick="toggleFullScreen();" src="./images/profile.png"></img>

--


<img class="profile-pic" src="./images/profile.png"></img>

## 

<strong>Noah Hall</strong>

</br>

</br>

</br>



<em>@eeue56</em>

--

## Personal motto

</br></br></br>

If it makes sense to do it in Elm, we _can_ do it in Elm.

--

## But..

</br></br></br>
Don't compromise the Elm experience 

--

## Elm expections

- No runtime errors
- No side effects without commands
- A really nice time

--

## osloelmday animation

```
// do demo
```

--

## osloelmday animation

```haskell
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs MoveAlong ]


viewTriangle : Triangle -> Svg msg
viewTriangle triangle =
    Svg.polygon
        [ points <| trianglePoints triangle
        ]
```


--

## osloelmday animation

```haskell





nav_ : Html a
nav_ =
  nav [ class "nav animate animate--fixed ticket_btn" ]
      [ a [ class "nav__signup", href "...", target "_blank" ]
          [ text "Get your ticket" ]
      ]
```

--

## osloelmday animation

```javascript



app.ports.init.subscribe(() => {
  ticket_btn_f = {
    wrapper: document.getElementById('ticket_btn'),
    animType: 'svg',
    autoplay: false,
    loop: false,
    path: 'ticket.json'
  };
  ticket_btn_anim = bodymovin.loadAnimation(ticket_btn_f);
}
```

--


## osloelmday animation

</br></br></br>
Doing everything in pure Elm is not always a good idea 


--

## elm-doc-test

```haskell


Adds two numbers together

  addTwo 0 3
  --> 3

  addTwo -6 9
  --> 3

addTwo : Int -> Int -> Int
addTwo x y = 
  x + y
```

--

## elm-doc-test

```haskell

tests : Test
tests =
  suite "addTwo"
    [ Expect.equal (addTwo 0 3) 3 
    , Expect.equal (addTwo -6 9) 3
    ]

```

--

## elm-doc-test


```haskell
var app = Elm.DocTest.worker(config);


app.ports.readFile.subscribe((filename) => {
  fs.readFile(filename, (text)=>{
    app.ports.generateModuleDoctest.send(filename, text); 
  });
});


app.ports.writeFile.subscribe(fs.writeFile);
```

--

## elm-doc-test

```haskell



{-| filename -}
port readFile : String -> Cmd msg


{-| filename, text -}
port writeFile : ( String, String ) -> Cmd msg


{-| filename, text -}
port generateModuleDoctest : (( String, String ) -> msg) -> Sub msg
```

--

## elm-doc-test

- Use ports for doing IO operations 
- Parse the text and build an AST 
- The core logic can be published on package.elm-lang.org!

--


## json-to-elm

```
// do demo
```

--

## json-to-elm

```haskell



type KnownType
    = MaybeType KnownType
    | ListType KnownType
    | IntType
    | FloatType
    | BoolType
    | StringType
    | ComplexType
    | ResolvedType String
    | Unknown
``` 

--

```haskell
knownTypesToEnglish : KnownTypes -> String
knownTypesToEnglish known =
    case known of
        Unknown ->
            "I don't know what this is"

        ComplexType ->
            "something that has to be written by hand!"

        ResolvedType name ->
            "a type that you've called " ++ (String.trim name)

        IntType ->
            "an int value"

        FloatType ->
            "a float value"

        StringType ->
            "a string value"

        BoolType ->
            "a boolean value"

        ListType nested ->
            "a list of " ++ (knownTypesToString nested)

        MaybeType nested ->
            "an optional value of " ++ (knownTypesToString nested)
```

--

## json-to-elm

```haskell




{-|
    >>> guessDecoder "User"
    "decodeUser"
    >>> guessDecoder "Int"
    "Json.Decode.int"
-}
guessDecoder : String -> String
guessDecoder typeName =
    if List.member (String.toLower typeName) knownDecoders then
        "Json.Decode." ++ (String.toLower typeName)
    else
        "decode" ++ (capitalize typeName)
```

--

## json-to-elm

- Read text in
- Generate an AST 
- Generate the code from the AST
- Or generate English!

--

# elm-server-side-renderer

```javascript
// do demo
```
--

```haskell




type ElmHtml msg
    = TextTag TextTagRecord
    | NodeEntry (NodeRecord msg)
    | CustomNode (CustomNodeRecord msg)
    | MarkdownNode (MarkdownNodeRecord msg)
    | NoOp
```

--


```haskell


{-| decode a node record
-}
decodeNode : HtmlContext msg -> Json.Decode.Decoder (NodeRecord msg)
decodeNode context =
    Json.Decode.map4 NodeRecord
        (field "tag" Json.Decode.string)
        (field "children" (Json.Decode.list (contextDecodeElmHtml context)))
        (field "facts" (decodeFacts  context))
        (field "descendantsCount" Json.Decode.int)
```

--

```haskell


stringify : a -> String
stringify =
    Native.ServerSideHelpers.stringify
```

```javascript


var ServerSideHelpers.stringify = function(x) { return JSON.stringify(x) };
```

--

- Native code is helpful for debugging and tools
- But every line you add is another line you can mess up

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

## Things to think about

- Generally, any problem is solvable in Elm
- Sometimes you shouldn't solve it in only Elm
- Ports are great! Native code is needed for 
- Modelling problems as an AST means you can generate differently shaped code


--


## An open statement

- Join the Elm Slack! (https://elmlang.slack.com/)
- We have a channel: `#osloelmday` and `#norway`
- All questions are answered
