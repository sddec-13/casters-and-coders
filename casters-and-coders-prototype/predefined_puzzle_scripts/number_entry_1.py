
# Some scripts, like this one, are "read only", often shortened to just "readonly".
# That means that you can read it, but you can't change it.
# You can tell if a script is readonly by the indicator by the "close" button.
# Of course, you could also tell by trying to change it - a readonly script can't be changed.


# Any line starting with a hash like this is a comment.
# Comments don't actually *do* anything. They're just for leaving notes


# Using the "def" keyword, we can create a function.
# "numbers_changed" is a hook for this puzzle, so it will be executed when something happens in the game.
# For "numbers_changed", it is executed when one of the number consoles are changed.

# In parentheses after the function name are function arguments. Sometimes these are also called parameters.
# These are inputs to the function, and you can use them to do things.

# You can see descriptions of "numbers_changed" and all its inputs in the panel on the left.
def numbers_changed(number_1, number_2, number_3):

	# You can use the "print" function to print any variable to the screen.
	# Try changing some numbers and see what it prints!
	print(number_1)

	# TODO: write more about this stuff
	if number_1 == 6:
		set_bridge_lowered(True)
	else:
		set_bridge_lowered(False)