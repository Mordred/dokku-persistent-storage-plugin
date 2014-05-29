# dokku-persistent-storage-plugin

[![Build Status](https://travis-ci.org/Mordred/dokku-persistent-storage-plugin.svg?branch=master)](https://travis-ci.org/Mordred/dokku-persistent-storage-plugin)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Mordred/dokku-persistent-storage-plugin/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

[Dokku](https://github.com/progrium/dokku) plugin to create persistent directories in the dokku container within application directory.
Inspired by [dokku-persistent-storage](https://github.com/dyson/dokku-persistent-storage).

## Installation

```bash
git clone https://github.com/Mordred/dokku-persistent-storage-plugin.git /var/lib/dokku/plugins/persistent-storage-plugin
```

## Commands

```bash
$ dokku help
    persistent-storage <app>                                          display current persistent directories within app
    persistent-storage:add <app> DIR_NAME [DIR_NAME2 ...]             add new directory which will persist across multiple deploys
    persistent-storage:remove <app> DIR_NAME [DIR_NAME2 ...]          remove previous added directories
    persistent-storage:clear <app>                                    remove all settings
```

## Simple usage

Your need to have app running with the same name!

```bash
$ dokku persistent-storage:add uploads                                 # Server side
$ ssh dokku@server persistent-storage:add uploads                      # Client side
```

This will create ```/app/uploads/``` directory inside application container which will be mapped to the host directory
```$DOKKU_ROOT/$APP/.storages/uploads/```.

## License
MIT
