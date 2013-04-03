use strict;
use warnings;
use Test::More;

{
    package Foo;
    use strict;
    use warnings;
    use parent 'Amon2';
    __PACKAGE__->load_plugin('Model');

    package Foo::Model::Base;
    sub new {
        my ($class, %params) = @_;
        bless \%params, $class;
    }

    package Foo::Model::Hoge;
    use base 'Foo::Model::Base';

    package Foo::Model::Fuga;
    use base 'Foo::Model::Base';

    package Foo::Model::Piyo;
    use base 'Foo::Model::Base';
}

my $c = Foo->bootstrap();

subtest 'single model' => sub {
    my $m1 = $c->model('Hoge' => { foo => 1 });
    isa_ok $m1, 'Foo::Model::Hoge';
    is $m1->{foo}, 1;
    ok ! defined $m1->{bar};

    my $m2 = $c->model('Fuga' => { bar => 2 });
    isa_ok $m2, 'Foo::Model::Fuga';
    ok ! defined $m2->{foo};
    is $m2->{bar}, 2;

    my $m3 = $c->model('Hoge');
    isnt "$m3", "$m1", '$m3 is not cache of $m1';

    my $m4 = $c->model('Fuga');
    isnt "$m4", "$m2", '$m4 is not cache of $m2';
};

subtest 'multiple models' => sub {
    my ($m1, $m2, $m3) = $c->model(
        'Hoge' => { foo => 1 },
        'Fuga',
        'Piyo' => { baz => 3 },
    );

    isa_ok $m1, 'Foo::Model::Hoge';
    is $m1->{foo}, 1;
    ok ! defined $m1->{bar};
    ok ! defined $m1->{baz};

    isa_ok $m2, 'Foo::Model::Fuga';
    ok ! defined $m2->{foo};
    ok ! defined $m2->{bar};
    ok ! defined $m2->{baz};

    isa_ok $m3, 'Foo::Model::Piyo';
    ok ! defined $m3->{foo};
    ok ! defined $m3->{bar};
    is $m3->{baz}, 3;
};

done_testing;
