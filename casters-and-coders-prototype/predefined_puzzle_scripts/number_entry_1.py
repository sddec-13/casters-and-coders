
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

	# Here we have an if/else statement.
	# If the expression after the "if" is true, the first indented block runs.
	# Otherwise, the second "else" block runs. The "else" block is optional.
	# We can test if two things are equal with the "==" operator.
	if number_1 == 6:
		# These are output functions, colored purple. They effect the game world outside the script.
		# A "bool", or boolean value just means True or False.
		set_bridge_lowered(True)
	else:
		set_bridge_lowered(False)