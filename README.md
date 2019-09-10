# NAME

DBIx::Class::InflateColumn::DateTimeTZFromSchema - Extend InflateColumn::DateTime for runtime configurable timezone selection

# SYNOPSIS

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

# DESCRIPTION

Subclass of [DBIx::Class::InflateColumn::DateTime](https://metacpan.org/pod/DBIx::Class::InflateColumn::DateTime), see parent
module documentation for complete usage details.

Parent module only provides for a hard-coded time zone and locale.  This module
provides for reconfiguring these anytime at runtime, by setting an attribute
on the Schema object.  Changing the value of $schema->timezone does not change
the timezone of already inflated column datetime objects.

Unlike parent module, which allows configuring the timezone on a per-column
basis, this module globally uses a single time zone and locale value everywhere.

# PROBLEMS

Module needs tests

# SEE ALSO

[DBIx::Class::InflateColumn::DateTime](https://metacpan.org/pod/DBIx::Class::InflateColumn::DateTime)

# COPYRIGHT AND LICENSE

This module is free software under the perl5 license

(c) 2019 Mitch Jackson <mitch@mitchjacksontech.com>
