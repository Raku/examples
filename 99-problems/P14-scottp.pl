#  Duplicate the elements of a list.
#  Example:
#    * (dupli '(a b c c d))<BR>
#    (A A B B C C C C D D)<P>

use v6;
sub dupli(@l) {
	return @l.map({$_, $_});
}
say dupli(<a b c c d>);

