package bbs2::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'bbs2::DB::Row';

table {
    name 'entry';
    pk 'id';
    columns qw(id body);
};

1;
