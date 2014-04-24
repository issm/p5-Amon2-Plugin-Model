use strict;
use warnings;
use Test::More;

{
    package Foo;
    use strict;
    use warnings;
    use parent 'Amon2';
    __PACKAGE__->load_plugin('Model');

    package Bar;
    use strict;
    use warnings;
    use parent 'Amon2';
    __PACKAGE__->load_plugin('Model', +{ store_name => 1 });

    package FooBar;
    use strict;
    use warnings;
    use parent 'Amon2';
    __PACKAGE__->load_plugin('Model', +{ store_name => 1 });

    package FooBar::Model::Hoge;
    sub new {
        my ($class, %args) = @_;
        my $name = $args{name};
        bless +{
            (defined $name ? ( name => $name ) : ()),
        }, $class;
    }
}

subtest 'exists' => sub {
    my $m1 = Foo->bootstrap()->model( '+FooBar::Model::Hoge' );
    my $m2 = Bar->bootstrap()->model( '+FooBar::Model::Hoge' );
    ok ! defined $m1->{name};
    ok defined $m2->{name};
    is $m2->{name}, '+FooBar::Model::Hoge';
};

subtest 'full/abbr' => sub {
    my $c = FooBar->bootstrap();
    my $m1 = $c->model( 'Hoge' );
    my $m2 = $c->model( '+FooBar::Model::Hoge' );
    is ref($m1), ref($m2);
    is $m1->{name}, 'Hoge';
    is $m2->{name}, '+FooBar::Model::Hoge';
};

done_testing;
