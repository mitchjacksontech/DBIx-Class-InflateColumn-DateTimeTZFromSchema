package DBIx::Class::InflateColumn::DateTimeTZFromSchema;

use strict;
use warnings;
use base 'DBIx::Class::InflateColumn::DateTime';

our $VERSION = '0.01';

=head1 NAME

DBIx::Class::InflateColumn::DateTimeTZFromSchema - Extend InflateColumn::DateTime for runtime configurable timezone selection

=head1 SYNOPSIS

Create accessors in your schema class for timezone and locale, and
define default values

  # MyApp/Schema.pm
  __PACKAGE__->mk_group_accessors(
    inherited => (qw/
      timezone
      locale
    /)
  );
  __PACKAGE__->timezone('America/Chicage');
  __PACKAGE__->locale('en_US');

Load component in your Result class

  # MyApp/Schema/Result/Thing.pm
  __PACKAGE__->load_components(qw/
    InflateColumn::DateTimeTZFromSchema
  /);

Reconfigure timezone and locale at runtime

  my $schema = MyApp::Schema->connection;
  
  # DT object has timezone from schema defaults
  say $schema->resultset('Thing')->first->created_at;
  
  # DT object inflated with updated timezone value
  $schema->timezone('America/New_York');
  say $schema->resultset('Thing')->first->created_at;

=head1 DESCRIPTION

Subclass of L<DBIx::Class::InflateColumn::DateTime>, see parent
module documentation for complete usage details.

Parent module only provides for a hard-coded time zone and locale.  This module
provides for reconfiguring these anytime at runtime, by setting an attribute
on the Schema object.  Changing the value of $schema->timezone does not change
the timezone of already inflated column datetime objects.

Unlike parent module, which allows configuring the timezone on a per-column
basis, this module globally uses a single time zone and locale value everywhere.

=cut

sub _post_inflate_datetime {
  my ( $self, $dt, $info ) = @_;

  my $schema = $self->result_source->schema;

  if ( $schema->can('timezone') && defined $schema->timezone ) {
    $dt->set_time_zone( $schema->timezone );
  } elsif ( defined $info->{timezone} ) {
    $dt->set_time_zone( $info->{timezone} );
  }

  if ( $schema->can('locale') && defined $schema->locale ) {
    $dt->set_locale( $schema->locale );
  } elsif ( defined $info->{locale} ) {
    $dt->set_locale( $info->{locale} );
  }

  return $dt;
}

=head1 PROBLEMS

Module needs tests

=head1 SEE ALSO

L<DBIx::Class::InflateColumn::DateTime>

=head1 COPYRIGHT AND LICENSE

This module is free software under the perl5 license

(c) 2019 Mitch Jackson <mitch@mitchjacksontech.com>

=cut

1;
