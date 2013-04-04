use strict;
use warnings;
use Test::More;

{
    package Foo;
    use strict;
    use warnings;
    use parent 'Amon2';
    __PACKAGE__->load_plugin('Model');

    package Foo::Bar;
    use strict;
    use warnings;
    use parent 'Amon2';
    __PACKAGE__->load_plugin('Model');

    package Foo::Model::Hoge;
    sub new { bless +{}, shift }
}

my $c1 = Foo->bootstrap();
my $c2 = Foo::Bar->bootstrap();

my $m1 = $c1->model('Hoge');
my $m2 = $c2->model('Hoge');

isa_ok $m1, 'Foo::Model::Hoge';
isa_ok $m2, 'Foo::Model::Hoge';

done_testing;
