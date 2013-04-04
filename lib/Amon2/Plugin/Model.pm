package Amon2::Plugin::Model;
use strict;
use warnings;
use Try::Tiny;
use Class::Load qw/load_class/;

our $VERSION = '0.02';

sub init {
    my ($class, $context_class, $config) = @_;

    no strict 'refs';
    *{"$context_class\::model"} = \&_model;
}

sub _model {
    my ($self, @args) = @_;
    die 'Model name is not specified.'  unless ( grep ref($_) eq '', @args );

    my $class_prefix = "@{[ref($self)]}::Model";

    my @models;
    while ( my $arg = shift @args ) {
        next if ref($arg) ne '';
        my ($model, $params);

        # ->model( $name => \%params )
        if ( @args > 0  &&  ref($args[0]) eq 'HASH' ) { $params = shift @args }
        $params ||= +{};

        try {
            my $model_class = __camelize($arg);
            unless ( $model_class =~ s/^\+// || $model_class =~ /^$class_prefix/ ) {
                $model_class = "$class_prefix\::$model_class";
            }
            load_class($model_class);
            $model = $model_class->new(
                c => $self,
                %$params,
            );
        } catch {
            my $msg = shift;
            die $msg;
        };

        if ( $model->can('init') ) {
            $model->init( %$params );
        }

        push @models, $model;
    }

    return wantarray ? @models : $models[0];
}

sub __camelize {
    my $t = shift;
    $t =~ s/(?:^|_)(.)/uc($1)/ge;
    $t =~ s/:([^:])/':'.uc($1)/ge;
    $t =~ s/^(\+.)/uc($1)/e;
    return $t;
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
