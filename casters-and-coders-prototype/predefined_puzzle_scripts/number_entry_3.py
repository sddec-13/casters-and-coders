
# Some scripts, like this one, are "read only", often shortened to just "readonly".
# That means that you can read it, but you can't change it.
# You can tell if a script is readonly by the indicator by the "close" button.
# Of course, you could also tell by trying to change it - a readonly script can't be changed.
# Soon, you'll see scripts that aren't readonly. Then, you'll get to write some of your own code!

def numbers_changed(number_1, number_2, number_3):

	# By putting an "f" before a string we can template variables into it with curly braces.
	print(f"The current numbers are: ({number_1}, {number_2}, {number_3})")

	# We can also use keywords like "and", and "or" to require a combination of conditions!
	if (number_1 * number_2) > 10 and number_3 == number_1:
		set_bridge_lowered(True)
	else:
		set_bridge_lowered(False)