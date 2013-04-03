use strict;
use Amon2::Plugin::Model;
use Test::More;

sub f { Amon2::Plugin::Model::__camelize(@_) }

is f( 'foobar' ), 'Foobar';
is f( 'foo_bar' ), 'FooBar';
is f( 'foo::bar' ), 'Foo::Bar';
is f( 'hoge_fuga::piyo::foo_bar_baz' ), 'HogeFuga::Piyo::FooBarBaz';

done_testing;
