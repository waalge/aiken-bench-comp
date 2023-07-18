# bench

> Aiken benchmark comp: a first draft

## About

We're not here to make real validators: we're here to ace synthetic benchmarks. 
The aim of is to explore what "best practice" means, and share ideas in how to write "good" aiken.

This is a live project and we'll add _challenges_ and their _tests_ as we go. 
Want to see a new challenge? Think the tests are cheatable? Raise an issue, discussion, or submit a PR! 

## Org 

This repo uses nix flakes. This is not imperative, but you'll need to figure out your own dependencies.
For non-flake setups you'll need to have aiken available, naturally.  The code gen scripts are written in lua.

`./bench` is a standard aiken repo with a bit of a difference. 

There is a `./templates` subdir.
Each subdir of `./templates` is a challenge directory. 
It contains a `_.ak` challenage file. This is what you need to complete to compete. 
The other files are the tests/ benchmarks. This is what you need to ace to win. 
Its TBC how to aggregate these to decide who is winning. 

## How to play

To play in challenge:
```sh
cp ./template/{{challenge}}/_.ak ./lib/{{user}}/{{challenge}}.ak
```
and complete the function(s).

We need to generate the tests for the challenge.
See below on how to set this up for the first time. 

Assuming `abc` is on path
```sh
# presuming youre running from proj root
abc gen ./bench 
abc run ./bench 
```
This outputs a `results.json` file. 

TODO: setup up github pages to render json as table.

NOTES: 
- Keep `{{user}}` as your github username, unless...  

## Setup 

If you're using nix, open up a devshell. 
The lua dependencies will be available. 

To install and make the lua scripts for the first time. 
```sh
abc-install
abc-make
```

Now `abc` is on path. 

## Entering the league table

Make sure your solutions commit is up-to-date with this repo.
Submit a PR with your entrants.
We'll get it merged and regenerate the league tables. (TODO : plumb in github pages)
