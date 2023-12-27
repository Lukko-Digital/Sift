# Overview
Dialogue for Sift is written and stored in `.idmu` (Ian Dialogue MarkUp) files. This document will walk you through how to write and format `.idmu` files. If you haven't already, it is suggested to familiarize yourself with Sift's dialogue architecture by reading `dialogue_architecture.md`.

NOTE: The dialogue system is very character sensitive, so make sure to set your `.idmu` to `LF` and not `CRLF` to make sure the carriage return character is not added.
# Header
The first two lines of each dialogue file is the info header. The header denotes the name of the interactable and the image of the interactable. The image is assumed to be the filename of an image in `res://assets/portraits/`.

Example header:
```
name: Guy
image: guy.png
```

# Writing Dialogue

The rest of the file is used for writing the **dialogue tree**. As a recap:
- The **dialogue tree** is made up of different **branches**
- Each **branch** has multiple **paths** (which are chosen based on the number of past interactions)
- Each **path** holds **dialogue lines**
- Each **dialogue line** can optionally have player **reponses**, or **branch switches**.

## Leading Characters

`.idmu` files work on a leading character system, meaning the first character in a line determines what the branch is.
- `~` denotes a branch
- `:` denotes a path
- `-` denotes a response
- `>` denotes a branch switch
- no leading character denotes a dialogue line

NOTE: It is technically a leading *two* character system, as a space is always expected after a leading character.

This will be accepted as a new branch.
```
~ O
```
This will NOT be accepted as a new branch
```
~O
```

## Sample `.idmu`

We will now go piece by piece through the `sample.idmu` file. The full file can be found at the bottom of this page, or in the `docs` folder.

NOTE: `sample.idmu` uses tabs to impove readability. Tabs are not required and are removed when parsing `.idmu` files.

### The Origin (O) Branch

The dialogue tree begin by creating the Origin (O) branch.
```
~ O
```
#### Path 0
Then, path 0 is created, the path that is entered when the player has completed branch O zero times before. In otherwords, the first time the player interacts with this NPC.
```
: 0
	oh hi im guy
	any questions comments concerns?
		- wait who are you again? > A
		- what am i doing here? > B
		- ja ne > E
```
The first line of dialogue is "oh hi im guy."

Then, the NPC asks, "any questions comments concerns?" and the player is given three possible reponses:

- The first response, "wait who are you again?" will take the player to branch A.
- The second response, "what am i doing here?" will take the player to branch B.
- The last reponse, "ja ne" will take the player to branch E

#### Path 1
Path 1, is created, the path that is entered when the player has completed branch 1 one or more times. In otherwords, every subsequent interaction the player has with this NPC.
```
: 1
	oh its you again
	any questions comments concerns?
		- wait who are you again? > A
		- what am i doing here? > B
		- ja ne > E
```
The first line of dialogue is now, "oh its you again."

However, the NPC asks the same question, "any questions comments concerns?" and the player is given the same responses.

### Branch A
Branch A is a short branch, reponding to the question from the player, "wait who are you again?"
```
~ A
: 0
	i'm guy
	> R
: 1
	cmon you already know
	> R
```
The first time the NPC responds to this question, they say, "i'm guy."

Every subsequent time the NPC responds to this question, they say, "cmon you already know."

After either reponses, they switch to the re-response (R) branch.

### In-line Info
If you wish to use a different name or image than the default defined in the header, or emit a signal via dialogue, you can do so with in-line info. In-line info is denoted in square brackets before the dialogue line, with a space after the open bracket, and both before and after the close bracket.

The following tags are used in in-line info
- `name: `
- `image: `
- `emit: `

#### Examples

stuff: YOU NEED COMMA SPACE BETWEEN EACH TAG, EMIT NEEDS TO NOT HAVE SPACES AFTER COMMAS, EMIT NEEDS TO BE IN THE EXACT SYNTAX OF THE CODE

Changing the name:
```
[ name: ??? ] oh hi im guy
```
Changing the image:
```
[ image: guy_shocked.png ] woah that's crazy
```
Emitting a signal:
```
[ emit: "set_world_var","quest_accepted",true ] thank you for accepting my quest
```

Using Multiple Tags:
```
[ name: ???, image: unknown.png ] *a mysterious figure approaches*
```


---

## `sample.idmu`
```
name: Guy
image: guy.png
~ O
: 0
	oh hi im guy
	any questions comments concerns?
		- wait who are you again? > A
		- what am i doing here? > B
		- ja ne > E
: 1
	oh its you again
	any questions comments concerns?
		- wait who are you again? > A
		- what am i doing here? > B
		- ja ne > E
~ A
: 0
	i'm guy
	> R
: 1
	cmon you already know
	> R
~ B
: 0
	your guess is as good as mine
	> R
: 1
	*shrugs*
	> R
~ E
: 0
	mata ne
	> EXIT
~ R
: 0
	anything else?
		- wait who are you again? > A
		- what am i doing here? > B
		- ja ne > E
```
