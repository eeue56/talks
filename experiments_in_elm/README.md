title: Experiments in Elm
author:
  name: Noah (eeue56)
  url: https://github.com/eeue56
  twitter: eeue56
output: basic.html
style: style.css
override: true
controls: true

--


# Experiments in Elm
## Push Elm to the limit

--


<img class="profile-pic" src="./images/profile.png"></img>

## Noah Hall
- @eeue56
- NoRedInk

--

### Things

- Improving Elm tooling for devops
- Take aways from Server side Elm
- The future of debugging

--


### elm-package

- manages dependencies and figures out what packages you need to download
- only downloads packages, doesn't compile
- packages hosted on github


--

### Github for package hosting

- Slow
- Flakey as a host
- Sometimes goes down

--

```elm
Noahs-MacBook-Pro:take-home noah$ time epi install --yes
Downloading NoRedInk/start-app
Downloading circuithub/elm-json-extra
Downloading elm-lang/core
Downloading evancz/elm-effects
Downloading evancz/elm-html
Downloading evancz/virtual-dom
Packages configured successfully!

real  0m9.856s
user  0m0.676s
sys 0m0.144s
```

--

### Elm in production: ops

- Tests run lots of times, github becomes a bottleneck
- `elm-package` unreliability meant slower tests
- One of the bigger pain points with Elm

--

### Evan joins NoRedInk

- One of the first issues brought up
- Spent a day talking about long term solutions
- Came up with a reasonable short term solution

--

```elm
Noahs-MacBook-Pro:take-home noah$ time epi install --yes --host http://192.168.99.100:32768/
Downloading NoRedInk/start-app
Downloading circuithub/elm-json-extra
Downloading elm-lang/core
Downloading evancz/elm-effects
Downloading evancz/elm-html
Downloading evancz/virtual-dom
Packages configured successfully!

real  0m0.568s
user  0m0.262s
sys 0m0.109s
```

--

### Going upstream

- Will be added to upstream `elm-package`
- Docker image for caching layer exists

--

# Server-side Elm



--

### Background

- Went to ReactiveConf, lots of people asked about server-side Elm
- At the time, NRI were looking for a new backend technology
- Decided to try it out on a small separate production problem


--


### NoRedInk/take-home

- Based off of fresheyeball's PoC
- Rewritten to work with server-side StartApp
- All non-library code written in Elm

--

### Supported features

- Full stack Elm
- Shared models
- Server-side rendering of static views
- CSS through elm-css

--

### Structure

- `src` for library code, wrappers around Node libraries
- `instance/server` for actual code, pure Elm

--

### Everything in Elm

- Write once, run everywhere
- Seemless function and type sharing
- Compile-time safety of server-client interactions

--


### User model

```elm
type alias User =
  { token : String
  , name : String
  , email : String
  , role : String
  , startTime : Maybe Moment
  , endTime : Maybe Moment
  , submissionLocation : Maybe String
  , test : Maybe TestEntry
  }
```

--

### Some user functions

```elm

initials : User -> String
initials user =
    String.words user.name
        |> List.map (String.left 1)
        |> String.join ""
        |> String.toUpper

```

--

### Data injection

- Sent as a json dump to client code
- Sent to Elm through a port on load
- Parsed through a Json Decoder to ensure the API from the server was as expected

--

### No need when your interactions share types

- Compile time checks instead of runtime checks
- API enforced at compile time, not runtime
- Ensures that your data is consistent on both sides

--

### Server-side rendering

- Works for pages that don't require interaction
- Done on half of the pages of the take-home site
- 0.17 will make this easier

--

### Should I use server side Elm?

- Not yet

--

### A day in the life of a server-side Elm programmer right now

- Write some business logic in Elm
- Realise that you need some library support that doesn't exist in Elm
- Spend the rest of the day fighting Node

--

### The battles

- A lot of libraries work based on mutation
```javascript
return Moment(moment).format().toObject();
```
- A liberal API doesn't work well with static typing
- There's not always a clear path to Elm integration

--

### Going forward

- Not in the near future
- More likely to be based on some platform that fits Elm's model, like Beam
- The advantages of having Elm everywhere will still remain

--

# The future of debugging with Elm

--

## Firebase

- Store syncronized data accessible by multiple clients
- A client may be a server
- Have to write update callbacks yourself

--

### Flux over the wire

- Use a server which implements flux with websockets to use as a store
- Influence frameworks like Relay

--

### Server-side Elm without the wires

- Right now server-side Elm is structured in a way such that actions can be run seemlessly on the server
- I'm working on a prototype of this with websocket support

--

### What about elm-reactor?

- Taking parts of the elm-reactor that capture actions
- Now we can sync the actions through use of websockets

--

### What about the rest of elm-reactor?

- Well, things in Elm are immutable
- Immutablity means actions sent over the wire should have the same result on each
- This allows us to "time-travel" by replaying certain actions from a given model start
- Now our sessions are synced both in real time and the past

--

### What about time travelling forward?

- Store session at a time on the server
- Then any time a new client joins, swap the runtime data out
- Now your new client is at the saved state

--

## What about different paths?

- Disable sync
- Login as two different users
- Enable sync
- Now you can ensure that the UX is the same for each user

--

### Key take aways
- Elm package improvements will be coming soon
- Server side Elm has revealed some good patterns
- Elm's implementation gives you a lot of power over the lifecycle of your applications
- Our developer tools will only get better

