package Devel::Toolbox::Man::Test;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                           #
#   Do not use this module directly. It only implements the POD snippets.   #
#                                                                           #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#============================================================================#


=head1 NAME

Devel::Toolbox::Man::Test - documentation of DT::Test::*

=head1 VERSION

This document describes Devel::Toolbox::Test::* version v0.0.0

=head1 DESCRIPTION

=over

I<< Quis custodiet ipsos custodes?  >> 
-- Juvenal, I<< Satires >>

=back

=head1 PHILOSOPHY

=head2 Tests cannot be tested.

This is the first principle of honest testing. Testing a test script with some other piece of code merely displaces the issue; now the tester tester must be tested. Therefore at some point an ultimate tester must be simple enough that its correctness can be validated by eye. 

The ideal test script contains no logic at all, merely a series of declarations of the form: 

    given:
        condition A
        condition B
        condition C
    wanted:
        result X
        result Y
        result Z 

In practice a YAML'ish, non-Perl format is excessively rigid; we want to preserve the traditional Perlish test script format. Thus the declaration of a case becomes, e.g.: 

    $script_obj->{case}{ my_case_name   }   = {
        sub     => \&Target::Module::some_function,
        args    => [qw| foo bar 42 |],
        want    => {
            return_is       => 'Roar!',
            quiet           => 1,
        },
    };  ## case

This is a single statement, nothing more than an assertion that: Given this target code with this set of arguments, these results are wanted. It is almost certain that any mistake in this statement stems from a misconception in the author's head about what C<< some_function() >> is actually intended to do. We will hope that the perl interpreter itself will catch any syntactical errors. 

We can, of course, do little to ensure the test script author understands the function of the target production code. We have merely avoided issues stemming from poorly constructed test script logic. So the author is free to concentrate on that production function. 

=head2 The gentleman's gentleman

The test script consisting of declarations of test cases must somehow be processed. The given target must be executed with the given arguments. We then have captured results; and we check these against the results we want. This processing is the responsibility of C<< ::Test::Valet >>. 

To be the perfect developer's valet, ::TV must present several faces, often somewhat contradictory. A formal OO approach will be too formal; but we employ many related techniques. 

::TV, of course, consists of a few modules of Perl code containing all the logic we redacted out of the user's test script. So ::TV must be tested; and to a high standard, too. How? 

=head2 Testers cannot test themselves

A container cannot contain itself; a mirror cannot reflect itself; and our testing module cannot be used to test itself. The snake may be able to swallow its own tail but it cannot swallow its mouth. Please excuse the lack of formal proof. I say that regardless of how matters are arranged, some untested element must remain outside the closed circle. So how can ::TV itself be tested? 

::TV's test battery exercises the testing module against a dummy target, L<< Acme::Teddy|Acme::Teddy >>. Each script defines the dummy differently; and each test case is processed by ::TV just as it would any target. So the test scripts are slightly more complex, but the testing module is exercised in exactly the same context as in normal use. Although ::TV reports the dummy functions properly, what it is really doing is confirming to us that it is, itself, correct. 

If our self-test is to be reasonably complete then our dummy must sometimes fail and ::TV report it I<< as >> failing. But then this is a I<< passing >> test of ::TV itself! So we provide means to set a C<< must_fail >> attribute on the case or check expected to fail. When ::TV sees this flag, it executes inside a vault and inverts the sense of the check: 'ok' becomes 'not ok', and bad is good. 


=head1 SEE ALSO

L<Some::Module|Some::Module>


=head1 THANKS

B<< mutable_malachi >> for letting me bounce so many ideas off his head that 
he now has several migranes. 

=head1 AUTHOR

Xiong Changnian C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2013 
Xiong Changnian C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut


## END MODULE
1;
#============================================================================#
__END__
