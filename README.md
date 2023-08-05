# Aiken Bench Comp

> share aiken code one solution at a time

## About

We're not here to make real validators: we're here to ace synthetic benchmarks.
The aim of is to explore what _best practice_ means, and share ideas in how to write _good_ aiken.

This is a live project and we'll add _challenges_ and extend their _tests_ as we go. 
Want to see a new challenge? Think the tests don't cover enough? Raise an issue, discussion, or submit a PR! 

## Repo organization

This repo uses nix flakes. This is not imperative, but you'll need to figure out your own dependencies.
For non-flake setups you'll need to have aiken available, naturally.  The code gen scripts are written in lua.

`./bench` is a standard aiken repo with a bit of a difference. 

There is an additional subdirectory called `./tests`.
Each subdirectory of `./tests` corresponds to a challenge.
It contains a solution template file `_.ak`. This is what you need to complete to compete. 
The other files are the test modules/ benchmarks. This is what you need to ace to win. 
Its TBC how to aggregate these to decide who is winning. 

## How to play

Go to the `./bench` directory.
Choose a challenge from the `./tests` subdirectory. 
Copy across the solution template to where _your_ solutions will go:
```sh
cp ./tests/{{challenge}}/_.ak ./lib/bench/{{user}}/{{challenge}}.ak
```
Complete the function(s).

We need to generate the tests for the challenge.
See below on how to set this up for the first time. 

Assuming `abc` is on path then
```sh
# presuming youre running from proj root.
abc gen ./bench 
abc run ./bench
```
This outputs a `results.json` file. 

If you want to try multiple versions you can. 
To do this, rather than having a single solution file `{{challenge}}.ak`,
have a solution directory instead.
Anything of the following form will be considered.
```
./lib/bench/{{user}}/{{challenge}}/{{version}}.ak
```
NOTES: 
- Its assumed that `{{user}}` is your github username

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
We'll get it merged and regenerate the league tables.
