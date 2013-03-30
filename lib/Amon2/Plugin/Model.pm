package Amon2::Plugin::Model;
use strict;
use warnings;
use Module::Find;
use Try::Tiny;

our $VERSION = '0.01';

sub init {
    my ($class, $context_class, $config) = @_;
    my ($class_prefix) = split /::/, $context_class;
    $class_prefix .= '::Model';
    useall $class_prefix;

    no strict 'refs';
    *{"$context_class\::model"}          = \&_model;
    *{"$context_class\::__models"}       = {};
    *{"$context_class\::__class_prefix"} = sub { $class_prefix };
}

sub _model {
    my ($self, @args) = @_;
    die 'Model name is not specified.'  unless ( grep ref($_) eq '', @args );

    my @names;
    while ( my $name = shift @args ) {
        next if ref($name) ne '';
        my ( $model, $params );
        if ( @args > 0  &&  ref($args[0]) eq 'HASH' ) { $params = shift @args }
        if ( ! defined ( $model = $self->{__models}{$name} ) ) {
            try {
                my $model_class = sprintf '%s::%s', $self->__class_prefix, (ucfirst $name);
                $model = $self->{__models}{$name} = $model_class->new(
                    c => $self,
                );
            } catch {
                my ($msg) = @_;
                die $msg;
            };
        }
        if ( $model->can('init') ) {
            $model->init( %$params );
        }
        push @names, $name;
    }

    return wantarray ? @{$self->{__models}}{@names} : $self->{__models}{$names[0]};
}

1;
__END__

=head1 NAME

Amon2::Plugin::Model -

=head1 SYNOPSIS

  use Amon2::Plugin::Model;

=head1 DESCRIPTION

Amon2::Plugin::Model is

=head1 AUTHOR

issm E<lt>issmxx@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
