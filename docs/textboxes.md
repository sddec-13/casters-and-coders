## Textboxes

This is a planned feature.

#### Preamble
Our game will include conversations with NPC characters. This will be done through on-screen text boxes, similar to many classic RPGs. This document serves to describe the requirements of our textbox system. Once it is finished, this document will also give some basic instruction for usage of the system.

#### Functionality
The functionality of textboxes will be defined by a data structure that they are provided, a `TextboxSequence`. This represents a series of segments of text to be displayed, as well as decisions which prompt branching paths and various control signals.

A `TextboxSequence` should be a list of three types of elements:
Plain text to be displayed,
A decision for the player to make, which itself holds a `TextboxSequence` to execute for each decision,
A signal which triggers some action,

###### Text
- Text boxes should be able to store an arbitrary sequence of segments of text.
- At the end of a segment of text, the player will be given a button prompt, so they can indicate when to display more text.
- If any segment of text exceeds the capacity of a textbox, it will be broken into smaller segments to fit.

###### Decisions
- Some segments should prompt for player input. This will consist of a prompt, and several options to choose from.
- Each selected option should different sequence of text segments.

###### Signals
- A sequence of text segments must be able to signal that the textbox should be closed.
- A sequence of text segments must be able to send an arbitray Godot signal to influence elements of the game scene.


