use v6;

# NOTE: Experimenting with documentation for tutorials / help

# P21 (*) Insert an element at a given position into a list.
# 
# Example:
# * (insert-at 'alfa '(a b c d) 2)
# (A ALFA B C D)

# a. Simple version
# 	@array	- your "@array" must always use "@" - even for a single element
#	.splice - Your array is also an object, you can call the method .splice
#		- offset - where to add (starting 0)
#		- length - how many to replace (0 for insert)
#		- What to add
my @array = <a b c d>;
@array.splice(1, 0, 'alfa');
say @array;

# b. Using a sub
# 	$inâ @arr, $pos - you can insert an array in the middle of your parameters
# 	The array is like a reference, so splice on the actual array, not a copy of	it
sub insert_at ($in, @arr, $pos) {
	@arr.splice($pos - 1, 0, $in);
}
my @array2 = <a b c d>;
insert_at('alfa', @array2, 2);
say @array2;
