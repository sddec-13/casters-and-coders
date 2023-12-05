


# In this game, you will write Python scripts.
# There are great online resources, like W3 Schools, where you can learn more about language features.
# This game is intended to be used in addition to such supplements.

# Any line starting with a hash like this is a comment.
# Comments don't actually *do* anything. They're just for leaving notes

def numbers_changed(number_1, number_2, number_3):

	# Here's a different print statement.
    # Notice that numbers are added like numbers, while strings of text are appended.
	print("The sum of all three numbers is: " + (number_1 + number_2 + number_3))

    # This is a little different! Can you figure out a solution?
	if number_1 + number_2 + number_3 == 21:
		set_bridge_lowered(True)
	else:
		set_bridge_lowered(False)