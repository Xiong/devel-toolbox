#!/usr/bin/env perl
#       sync.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

# Core modules
use lib 'lib';
use Cwd;                        # get pathname of current working directory
use File::Spec;                 # Portably perform operations on file names

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
use Test::Trap;                 # Trap exit codes, exceptions, output, etc.
use Linux::Inotify2;            # Watch folder notifications

# Alternate uses
use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# Pseudo-globals
my $err     = Error::Base->new(
    -base   => "! $0:"
);
my $watch_mask  
    = 0
#~     | IN_ACCESS         # object was accessed
    | IN_MODIFY         # object was modified
    | IN_ATTRIB         # object metadata changed
#~     | IN_CLOSE_WRITE    # writable fd to file / to object was closed
#~     | IN_CLOSE_NOWRITE  # readonly fd to file / to object closed
#~     | IN_OPEN           # object was opened
    | IN_MOVED_FROM     # file was moved from this object (directory)
    | IN_MOVED_TO       # file was moved to this object (directory)
    | IN_CREATE         # file was created in this object (directory)
    | IN_DELETE         # file was deleted from this object (directory)
    | IN_DELETE_SELF    # object itself was deleted
    | IN_MOVE_SELF      # object itself was moved
#~     | IN_ALL_EVENTS     # all of the above events
    ;

#----------------------------------------------------------------------------#
### $0 Running...

# This is all done once on script startup.
my @current_path_parts  = File::Spec->splitdir(getcwd());
my $proj     = $current_path_parts[$#current_path_parts];
#~ ### @current_path_parts
### $proj

my $pairs  = {
#   installed filesystem        project development
     "~/.config/$proj"      => "sync/tilde/.config/$proj",  # /home/$user
       ".config/$proj"      => "sync/cwd/.config/$proj",    # current dir
#~     "/usr/share/$proj"      => "sync/rush/$proj",           # RootUserSHare
#~                                                             # needs 'sudo'
};

# Duplicate flipped.
for ( keys $pairs ) {
    my $A           = $_;
    my $B           = $pairs->{$A};
    $pairs->{$B}    = $A;
};
### $pairs

# Be sure all dirs exist...
for my $dir ( keys $pairs ) {
    my $c   = "mkdir -p $dir";      # mkdir will not clobber existing
    my $rv  = system $c;
    if ( $rv ) {                    # 0 == success
        $err->crash("Executing '$c' got exit code $rv:"); 
    };
};

# It's a matter of blind fate which gets clobbered by rsync.
# You really do want to have your dirs already sync'd FIRST.
for my $in_dir ( keys $pairs ) {
    my $out_dir     = $pairs->{$in_dir};
#~     my $c   = "rsync -av $in_dir/ $out_dir";    # trailing slash see man rsync
    my $c   = "rsync -a $in_dir/ $out_dir";    # trailing slash see man rsync
    my $rv  = system $c;
    if ( $rv ) {                    # 0 == success
        $err->crash("Executing '$c' got exit code $rv:"); 
    };
};

# inotify setup.
my $inotify     = Linux::Inotify2->new()
    or $err->crash("Unable to create new inotify object: $!");
for my $watch_dir ( keys $pairs ) {
    $inotify->watch (
        $watch_dir,
        $watch_mask,
    );
};


#~ sync({
#~     -pairs      => $pairs,
#~     -sync_dir   => $sync_dir,
#~ });

### $0 Done...
exit 0;

#----------------------------------------------------------------------------#

sub sync {
    my $args        = shift;
    my $chng_dir    = $args->{-chng_dir}    // $err->crash('-chng_dir needed');
    my $sync_dir    = $pairs->{$chng_dir}   ;
    
    my $c   = "rsync -a --delete $chng_dir/ $sync_dir"; # delete extraneous
    my $rv  = system $c;
    if ( $rv ) {                    # 0 == success
        $err->crash("Executing '$c' got exit code $rv:"); 
    };
};


#============================================================================#
__END__     
