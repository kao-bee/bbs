bbs
===

# bbs

* clone this repository
* install carton from cpanm
$ cpanm Carton

## mysql setting
$ mysqld start # for linux
$ mysql.server start # for mac

$ mysqladmin -uroot create bbs
$ mysql -uroot bbs < sql/mysql.sql

## carton install
$ cd (this repository)
$ carton install

## change configue/development.pl
```development.pl
# before
     'DBI' => [
          'dbi:mysql:bbs', 'root', '',
          +{ mysql_enable_utf8 => 1 },
      ],
```

```development.pl
#after
      'DBI' => [
          'dbi:mysql:bbs', 'yourUserName', 'yourPassword',
          +{ mysql_enable_utf8 => 1 },
      ],
```

## start bbs2
$ carton exec perl -Ilib script/bbs2-server
