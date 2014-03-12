# Hubot Marta

Marta APIs made (hopefully) accessible in hubot form.

[![Build Status](https://travis-ci.org/jakswa/hubot-marta.png)](https://travis-ci.org/jakswa/hubot-marta)

## Usage

The most basic syntax is:

```
You> !train for chamblee
Hubot> northbound gold train will arrive at CHAMBLEE STATION in 12 minutes
```

But you'll usually want only trains going a certain direction, or maybe on a certain line. Here's the full accepted syntax:
`!train [headed <dir> ][on <line> ][bound for <dest> ] (for|from) <station>`

Usually you'll only want to mix, at most, two out of the three optional filters. For example, here's two ways to get the next northbound train headed for chamblee:

```
You> !train headed north on gold for chamblee
Hubot> northbound gold train will arrive at CHAMBLEE STATION in 8 minutes
```
will give you the same train as
```
You> !train bound for doraville from chamblee
Hubot> northbound gold train will arrive at CHAMBLEE STATION in 7 minutes
```

## API-related caveats

- A train stopped at its final destination (like doraville or north springs) will not "switch directions" in the API until it leaves. So you'll only see northbound trains for north springs (`!train for north springs`), and you'll only see southbound trains for airport (`!train for airport`). Same for the east/west extremes.
- The API currently doesn't give estimates for trains about to change directions. If a train leaves chamblee, and it's next stop is doraville, there won't be an estimate for when that train turns around and hits chamblee again. Because of this, you'll find certain filters usually yield no results, like `!train headed south for chamblee`. A workaround is to watch the northbound train that is about to switch directions: `!train headed north for doraville`.

## Installation

Add the package `hubot-marta` as a dependency in your Hubot package.json file. Then add `hubot-marta` to the list in the `external-scripts.json` file.
