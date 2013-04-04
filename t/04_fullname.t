use strict;
use warnings;
use Test::More;

{
    package Foo;
    use strict;
    use warnings;
    use parent 'Amon2';
    __PACKAGE__->load_plugin('Model');

    package MyModel::Hoge::Fuga;
    sub new {
        my ($class, %params) = @_;
        bless +{ %params }, $class;
    }
}

my $c = Foo->bootstrap();

my $m1 = $c->model('+MyModel::Hoge::Fuga');
isa_ok $m1, 'MyModel::Hoge::Fuga';

my $m2 = $c->model('+MyModel::Hoge::Fuga' => { foo => 1 });
isa_ok $m2, 'MyModel::Hoge::Fuga';
is $m2->{foo}, 1;
isnt "$m2", "$m1", '$m2 is not cache of $m1';

done_testing;
