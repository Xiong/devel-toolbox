package Devel::Toolbox::Core::App;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
#~ use File::Spec;                 # Portably perform operations on file names
#~ use File::Copy;                 # Copy files or filehandles

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace

# Project module
use Devel::Toolbox;             # Simple custom project tool management
use Devel::Toolbox::Core::Config
    qw| load_config_files |;

# Alternate uses
#~ use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

# Pseudo-globals
my $err = Error::Base->new (
    -base           => '! DTC-App:',
);

our $U      = get_global_pool();            # common to all toolsets
### App-package
### $U

## pseudo-globals
#----------------------------------------------------------------------------#
# METHODS

#=========# EXTERNAL FUNCTION
#~ my $perl_exit   = Devel::Toolbox::Core::App::app_execute({});  # 1 for okay
#
#   Runs the dt application. Normally invoked only by script, $ dt <usage>
#   
#   $option     hashref containing all command line options 
#                (such as -n, -v, --help) as output by Getopt::*
#   
#   $words      arrayref containing all the barewords on command line
#   
#   See: dt, DTC::Pool
#   
sub app_execute {
    my $args        = shift;    # arguments to invocation itself
    ### App-execute
    ### $U
    my $option      = $U->{main}{cmdline_opt};
    my $words       = $U->{main}{cmdline_words};
    
    # Option handling here.                                 TODO
    
    # Load after option processing; 
    #   might pass arg to optionally load different config files
    load_config_files();     # load from disk and merge contents into $U
    
    # Dispatch
    my $set_name            = ucfirst shift $words;
    my $tool_name           = shift $words;
    my $import_name         = join q{_}, lc $set_name, $tool_name;
    ### $set_name
    ### $tool_name
    ### $import_name    
    ### $words
    
    claim "::$set_name";        # expands and imports mashed-up: set_tool()
    ### App (after claim'ing set)
    ### $U
    
    {
        no strict 'refs';
        &{ "$import_name" }(@$words);
    }
    
    return 1;
}; ## app_execute






## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Core::App - .................. 44 chars in PAUSE upload!

=head1 VERSION

This document describes Devel::Toolbox::Core::App version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Core::App;

=head1 DESCRIPTION

=over

I<Anyone can tell the truth, 
but only very few of us can make epigrams.> 
-- W. Somerset Maugham

=back

=head1 METHODS 

=head2 new()

=head1 ACCSESSORS

Object-oriented accessor methods are provided for each parameter and result. 
They all do just what you'd expect. 

    $self               = $self->put_attr($string);
    $string             = $self->get_attr();

=head1 SEE ALSO

L<Some::Module|Some::Module>

=head1 INSTALLATION

This module is installed using L<Module::Build|Module::Build>. 

=head1 DIAGNOSTICS

=over

=item C<< some error message >>

Some explanation. 

=back

=head1 CONFIGURATION AND ENVIRONMENT

None. 

=head1 DEPENDENCIES

There are no non-core dependencies. 

=over

=item 

L<version|version> 0.99    E<nbsp>E<nbsp>E<nbsp>E<nbsp> 
# Perl extension for Version Objects

=back

This module should work with any version of perl 5.16.2 and up. 
However, you may need to upgrade some core modules. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any issues to: 
L<https://github.com/Xiong/devel-toolbox/issues>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: 
L<https://github.com/Xiong/devel-toolbox>. 

=head1 THANKS

Somebody helped!

=head1 AUTHOR

Xiong Changnian  C<< <xiong@cpan.org> >>

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





