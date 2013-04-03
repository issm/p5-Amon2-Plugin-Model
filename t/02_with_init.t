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
    sub new { bless {}, shift }

    package Foo::Model::Hoge;
    use base 'Foo::Model::Base';

    package Foo::Model::Fuga;
    use base 'Foo::Model::Base';
    sub init { shift->{fuga} = 1 }
}

my $c = Foo->bootstrap();
isa_ok $c, 'Foo';
ok $c->can('model');

my $m1 = $c->model('Hoge');
isa_ok $m1, 'Foo::Model::Hoge';

my $m2 = $c->model('Fuga');
isa_ok $m2, 'Foo::Model::Fuga';
is $m2->{fuga}, 1;

done_testing;
