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


# Elm & Build tools
## Walking on fresh snow

--


<img class="profile-pic" src="./images/profile.png"></img>

## Noah Hall
- @eeue56
- Fusetools
- Previously NoRedInk

--

### Things

- How does elm-package work?
- How do Elm-based build tools work?
- Some cool tricks with webpack


--


### elm-package

- manages dependencies and figures out what packages you need to download
- packages hosted on github
- package metadata is hosted on package.elm-lang.org

--

### Github for package hosting

- Slow
- Flakey as a host
- Sometimes goes down
- Tests run lots of times, github becomes a bottleneck
- `elm-package` unreliability meant slower tests
- One of the bigger pain points with Elm

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


### Just copy things

- `elm-stuff/packages` can be copied and shared
- `elm-stuff/build-artifacts` can be dangerous to copy
- Avoid symlinking

--

### elm-make
- Comes with Elm
- Used for compiling Elm
- No watching
- No dev/production flags
- No support for JS/CSS

--

### Build tools


- Webpack
  - Watching
  - Bundles of code
  - Good production/dev flags
  - Support for all your frontend
  - Some caching
- Brunch
  - Similar to webpack

--
### Webpack

- node-elm-compiler
- take a folder
- find Elm modules 
- add to watchers
- compile an Elm file into a JS file

--

### Example

- Main.elm

```elm

module Main exposing (..)
import Model
import Update

```

- Model.elm

```elm
module Model exposing (..)
```

- Update.elm

```
module Update exposing (..)
import Model
```

--

### Finding deps

- `findAllDependencies`
  - Look through files recursively
- `newImports`
  - Parse out new imports

--

### I see trees of green

```js
fs.readFile(file, {encoding: "utf8"}, function(err, lines) {
  if (err) {
    reject(err);
  } else {
    // Turn e.g. ~/code/elm-css/src/Css.elm
    // into just ~/code/elm-css/src/
    var newImports = _.compact(lines.split("\n").map(function(line) {
      var matches = line.match(/^import\s+([^\s]+)/);

      if (matches) {
        // e.g. Css.Declarations
        var moduleName = matches[1];

        // e.g. Css/Declarations
        var dependencyLogicalName = moduleName.replace(/\./g, "/");

        // e.g. ~/code/elm-css/src/Css/Declarations.elm
        var result = path.join(baseDir, dependencyLogicalName)

        return _.includes(knownDependencies, result) ? null : result;
      } else {
        return null;
      }
    }));

```
-- 

### Red roses too

- Max number of watches
- Node would hit max memory usage
- Webpack build times increased _hugely_
- Errors would happen based entirely randomly on how webpack processed things


-- 

### I see them bloom

- Rewrite node-elm-compiler!
- Only parse modules in watch mode!
- Parse modules lazily as possible, reading only what's needed

--

### For me and for you

```js

function readImports(file){
    return new Promise(function(resolve, reject){
        // read 60 chars at a time. roughly optimal: memory vs performance
        var stream = fs.createReadStream(file, {encoding: 'utf8', highWaterMark: 8 * 60});
        var buffer = "";
        var parser = new Parser();

        stream.on('data', function(chunk){
            buffer += chunk;
            // when the chunk has a newline, process each line
            if (chunk.indexOf('\n') > -1){
                var lines = buffer.split('\n');

                lines.slice(0, lines.length - 1).forEach(parser.parseLine.bind(parser));
                buffer = lines[lines.length - 1];

                // end the stream early if we're past the imports
                // to save on memory
                if (parser.isPastImports()){
                    stream.destroy();
                }
            }
        });
    });
}
```

--

### And I sing to myself

- 700 line files only loaded in memory for 20 lines
- Reduced memory usage by about 50% (1.1GB -> 400MB)
- 3x faster build times 
- 30x less open file watchers

--

### What a wonderful world

- Limit the number of Elm-make processes to 1
- Avoid parsing Elm source code as part of your build chain
- Avoid parsing at all before elm-make

--

### Deploying modern web applications

- Large websites need static content to be hosted by CDNs
- When static content is put on CDN, the filename often changes
- Locally, developers still refer to assets by standard path


-- 

### Assets get sha'd

```python
"/asset/star.png"
```

might get turned into

```python
"/asset/star344r592we993sd.png"
```

---

### Example of a view in Elm

- How can we turn

```elm

viewStar : Html msg
viewStar =
    img [ src "/assets/star.png" ] [ ]

```

- into..

```elm
viewStar : Html msg
viewStar =
    img [ src "/assets/star344r592we993sd.png" ] [ ]

```

--

### Decisions

- Process Elm before compile
  - But that involves fully parsing Elm!
- Process Elm after compile
  - How?

--


### Post-processing Elm

```elm

type AssetUrl = AssetUrl String

toUrl : AssetUrl -> String

```

```elm

starAsset = AssetUrl "/assets/star.png"

viewStar : Html msg
viewStar =
    img [ src <| toUrl starAsset ] [ ]
```

- locally
```elm
<img src="/assets/star.png" />
```

- production
```elm
<img src="/assets/star344r592we993sd.png" />
```

--

### How

- AssetUrl looks like this in dev

```js
var AssetUrl = function(str){
  return { 
    "ctor": "AssetUrl",
    "_0": str
  }
}
```

- babel in production!

```js
var AssetUrl = function(str){
  return { 
    "ctor": "AssetUrl",
    "_0": require(str)
  }
}
```

--
## Go check it out!

- https://github.com/NoRedInk/elm-asset-path
- https://github.com/NoRedInk/elm-assets-loader

--

### Key take aways
- It's easy to solve elm-package slowness through caching
- Avoid writing your own build tools
- Post-processing compiled Elm allows you to have JS capabilities
