package Devel::Toolbox::Set::New;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use File::Spec;                 # Portably perform operations on file names
use File::Copy();               # Copy files or filehandles
#~ use File::Path                  # Create or remove directory trees
#~     qw| make_path |;

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
use Text::Template;             # Expand template text with embedded Perl
use File::Path::Tiny;           # mk(), rm() dirs with less overhead

# Project module
use Devel::Toolbox;             # Simple custom project tool management

# Alternate uses
#~ use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

# Pseudo-globals
my $err     = Error::Base->new(
    -base           => '! DTC-New:',
);

our $U      = get_global_pool();            # common to all toolsets

## pseudo-globals
#----------------------------------------------------------------------------#
# METHODS

#=========# EXTERNAL FUNCTION
#~ module({ module => $dir });
#
#   Create a new module in an existing project.
#   $dir and $u->module_template must both be platform-expanded; e.g.: 
#       $dir                = /home/foo/projects/bar/lib/
#       $u->module_template = /home/foo/.config/templates/Module.pm
#   
#   template_delimiters can be any pair of strings; watch for conflicts!
#   All other arguments and all existing keys are available to templates!
#   
sub module;     # forward
declare {
    name        => 'module',
    sub         => \&module,
};
sub module {
    my $args        = shift;
    my $module      ;
#~     my $u               ;
#~     %$u                 = %$U;      # local copy this sub only
    
    
    # Polymorphic API.
    if    ( ref $args eq 'HASH' ) {
        $module     =  $args->{module}     # name of new module
                    // $args->{module_name}
                    // $args->{new_module_name}
                    // 'FOO::BAR'
                    ;
    }
    elsif ( ref $args eq 'SCALAR' ) {
        $module     = $$args;
        $err->crash("Unsupported args in call to New::module(): $args");
    }
    elsif ( ref $args eq 'ARRAY' ) {
        $module     = shift @$args;
        $err->crash("Unsupported args in call to New::module(): $args");
    }
    else {
        $module     = $args;
        $args       = { new_module_name => $module };
    };
    
    # Obtain flattened $U for template substitution.
    my $u       = flat_from_pool({ 
#~         want_keys       => ['foo'],         # all keys by default
        strip_level     => 1,
    });
    ### Flat pool in New:
    ### $u
    
    # Merge this functions's arguments with pool for template substitution.
    %{$u}       = ( %{$u}, %{$args} );
    
    # Do the substitution.
    my $tt_delimiters   = [
        $u->{template_delimiters__0}, 
        $u->{template_delimiters__1},
    ];
    my $tt      = Text::Template->new(
                    SOURCE      => $u->{new_module_template},
                    DELIMITERS  => $tt_delimiters,
                );
    $err->crash("Couldn't use template: $u->{new_module_template}")
        if not $tt;
    
    ### New-template-ready
    ### $u
    my $out     = $tt->fill_in( HASH => $u );
    
    # Figure out the qualified relative filename.
    my @path_parts      = ( 'lib', split q{::}, $module );
    my $module_file_rel = File::Spec->catfile( @path_parts ) . q{.pm};
    ### $module_file_rel
    ### @path_parts
    
    # Create any missing dirs along the path.
    pop @path_parts;    # no sense creating a dir with the actual filename
    my $path        = File::Spec->catdir(@path_parts);
    File::Path::Tiny::mk($path)
        or $err->crash("Failed to make path $path");
    
    # Put new module file
    open my $m_fh, '>', $module_file_rel
                or $err->crash("Failed to open $module_file_rel for writing.");
    print {$m_fh} $out
                or $err->crash("Failed while writing $module_file_rel");
    close $m_fh
                or $err->crash("Failed to close $module_file_rel after writing.");
    
    return 1;
}; ## module

#=========# DUMMY FUNCTION
sub foolish;   # forward
declare {
    name        => 'foolish',
    sub         => \&foolish,
};
sub foolish { 1 };


## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Set::New - Create a project, module, test, or toolset

=head1 VERSION

This document describes Devel::Toolbox::Set::New version v0.0.0

=head1 SYNOPSIS

    $ dt help new
    $ dt list new
    $ dt new My::Dist
    $ dt new module My::Module
    $ dt new test fubar
    $ dt new tool foo

=head1 DESCRIPTION

=head1 METHODS 

=head2 module()

    $self->module();
    $self->module( $template );

Create a new module from templates/Module.pm or from $template if given.

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

L<version|version> 0.99    
    E<nbsp>E<nbsp>E<nbsp>E<nbsp> # Perl extension for Version Objects

=back

This module should work with any version of perl 5.16.2 and up. 
However, you may need to upgrade some core modules. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any bugs or feature requests, or other issues through 
the web interface at
L<https://github.com/xiong/devel-toolbox/issues>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: 
L<https://github.com/xiong/devel-toolbox>. 

=head1 THANKS

Somebody helped!

=head1 AUTHOR

Xiong Changnian  C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2013 Xiong Changnian C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut

