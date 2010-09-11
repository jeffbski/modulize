# Modulize

Safe, easy method extension

## Improvement on manual aliasing

 - in aliasing, you have to worry about others using same name for old alias (not unique)
 - http://whynotwiki.com/Ruby_/_Method_aliasing_and_chaining - discusses alias chaining and a facet or ActiveSuppport method called alias_method_chain, however still can cause infinite loop and need to know what method to call if you want to delegate up the chain.
 - must check if alias already exists before doing, no guarantee that everyone will use unique feature names
 - Ara Howard suggests this solution to be a nicer alias_method_chain allowing super, but I find it hard to understand and and more code
 - Jay Fields mentions a technique to get reference to unbound method, then call it from in a define_method, so that you do not leave any artifacts around like the old method. This involves re-opening the class. http://blog.jayfields.com/2006/12/ruby-alias-method-alternative.html

## TODO

 - Make class methods work too

## Note on Patches/Pull Requests

 - Fork the project.
 - Make your feature addition or bug fix.
 - Add tests/specs for it. This is important so I don't break it in a future version unintentionally.
 - Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
 - Send me a pull request. Bonus points for topic branches.



## Copyright

Copyright (c) 2010 Jeff Barczewski. See LICENSE for details.


