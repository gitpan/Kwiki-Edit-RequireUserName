package Kwiki::Edit::RequireUserName;

use warnings;
use strict;
use Kwiki::Edit '-Base';
use mixin 'Kwiki::Installer';

our $VERSION = '0.01';

const class_title => 'Require UserName to edit';

sub register {
  my $registry = shift;
  $registry->add(action   => 'edit_noUserName');
  $registry->add(action   => 'edit');
  $registry->add(action   => 'edit_contention');
  $registry->add(toolbar  => 'edit_button', 
		 template => 'edit_button.html',
		 show_for => ['display', 'revisions', 'edit_contention'],
		);

}

sub edit {
  my $page = $self->pages->current;
  if (! $self->have_UserName) {
    my $page_uri = $page->uri;
    return $self->redirect("action=edit_noUserName&page_id=$page_uri");
  }
  super;
}

sub have_UserName {
  my $current_name   = $self->hub->users->current->name ||
    die "Can't determine current UserName";
  my $anonymous_name = $self->config->user_default_name ||
    die "Can't determine local name of anonymous user";  # set in
                                                         # config/user.yaml
  return ($current_name ne $anonymous_name);
}

sub edit_noUserName {
    return $self->render_screen(
        content_pane => 'edit_noUserName.html',
    );
}

1;

__DATA__

=head1 NAME

Kwiki::Edit::RequireUserName - Replaces Kwiki::Edit in order to require a user name to edit

=head1 SYNOPSIS

This plugin helps reduce WikiSpam by requiring that the user have a
user name before editing.  The idea is that SpamBots won't take the
trouble to do this.  Of course this won't prevent spam created
manually.

=head1 REQUIRES

   Kwiki 0.33 (tested against this version)
   Kwiki::Edit (comes standard with Kwiki)
   Kwiki::UserName (adds user name functionality to Kwiki)
   Kwiki::UserPreferences (adds the ability to change user names)


=head1 INSTALLATION

   perl Makefile.PL
   make
   make test
   make install

   cd ~/where/your/kwiki/is/located
   vi plugins

Replace

   Kwiki::Edit

with

  Kwiki::Edit::RequireUserName

If you don't already have them add the following also

  Kwiki::UserName
  Kwiki::UserPreferences

Then run

  kwiki -update

=head1 AUTHOR

James Peregrino, C<< <jperegrino@post.harvard.edu> >>

=head1 ACKNOWLEDGEMENTS

This extension of Kwiki::Edit was inspired by the techniques used in
Kwiki::Scode by Kang-min Liu.

=head1 BUGS

Please report any bugs or feature requests to
C<bug-kwiki-edit-requireusername@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically
be notified of progress on your bug as I make changes.

=head1 Copyright & License

Copyright 2004 James Peregrino, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
__template/tt2/edit_noUserName.html__
<!-- BEGIN edit_noUserName.html -->
<div class="error">
<p>
This web site does not allow anonymous editing.  Please go to <a
href="?action=user_preferences">User Preferences</a> button and create
a UserName for yourself.
</p>
<p>
</p>
</div>
<!-- END edit_noUserName.html -->
__template/tt2/edit_button.html__
<!-- BEGIN edit_button.html -->
[% rev_id = hub.revisions.revision_id %]
<a href="[% script_name %]?action=edit&page_id=[% page_uri %][% IF rev_id %]&revision_id=[% rev_id %][% END %]" accesskey="e" title="Edit This Page">
[% INCLUDE edit_button_icon.html %]
</a>
<!-- END edit_button.html -->
