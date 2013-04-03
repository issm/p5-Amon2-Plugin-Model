use strict;
use warnings;
use Test::More;

{
    package Foo;
    use strict;
    use warnings;
    use parent 'Amon2';
    __PACKAGE__->load_plugin('Model');

    package Foo::Model::Hoge;
    sub new { bless {}, shift }

    package Foo::Model::Fuga;
    sub new { bless {}, shift }

    package Foo::Model::Piyo::BarBaz;
    sub new { bless {}, shift }
}

my $c = Foo->bootstrap();
isa_ok $c, 'Foo';
ok $c->can('model');

subtest 'basic, single' => sub {
    my $m;
    $m = $c->model('Hoge');
    isa_ok $m, 'Foo::Model::Hoge';
    $m = $c->model('Fuga');
    isa_ok $m, 'Foo::Model::Fuga';
    $m = $c->model('Piyo::BarBaz');
    isa_ok $m, 'Foo::Model::Piyo::BarBaz';
};

subtest 'basic, multiple' => sub {
    my @m = $c->model(qw/Piyo::BarBaz Hoge Fuga/);
    isa_ok $m[0], 'Foo::Model::Piyo::BarBaz';
    isa_ok $m[1], 'Foo::Model::Hoge';
    isa_ok $m[2], 'Foo::Model::Fuga';

    my $m = $c->model(qw/Piyo::BarBaz Hoge Fuga/);
    isa_ok $m, 'Foo::Model::Piyo::BarBaz';
};

subtest 'cache' => sub {
    my ($m1, $m2);
    $m1 = $c->model('Hoge');
    $m2 = $c->model('Hoge');
    isa_ok $m1, 'Foo::Model::Hoge';
    isa_ok $m2, 'Foo::Model::Hoge';
    isnt "$m2", "$m1", '$m2 is not cache of $m1';

    my ($m3, $m4, $m5);
    $m3 = $c->model('Fuga');
    $m4 = $c->model('Hoge');
    $m5 = $c->model('Fuga');
    isa_ok $m3, 'Foo::Model::Fuga';
    isa_ok $m4, 'Foo::Model::Hoge';
    isa_ok $m5, 'Foo::Model::Fuga';
    isnt "$m4", "$m1", '$m4 is not cache of $m1';
    isnt "$m5", "$m3", '$m5 is not cache of $m3';
};

subtest 'lower-cased name' => sub {
    my $m;
    $m = $c->model('hoge');
    isa_ok $m, 'Foo::Model::Hoge';
    $m = $c->model('piyo::bar_baz');
    isa_ok $m, 'Foo::Model::Piyo::BarBaz';
};

done_testing;
