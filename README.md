# mongo-ruby-driver-segfault

This is the example that `mongo-ruby-driver` causes the segfault.

## Prerequisites

[Install Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

## How to use

```
$ docker-compose run ruby /bin/bash

> dns_local_ip_address=`ping -c 1 dns.local | head -1 | sed -E 's/.*\(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)\).*/\1/'`
> echo -e "nameserver ${dns_local_ip_address}\n$(cat /etc/resolv.conf)" > /etc/resolv.conf
> ruby main.rb
```

## Special Thanks

- https://github.com/bitnami/bitnami-docker-mongodb-sharded
- My Colleagues (ABC order)
  - @motobrew
  - @mtsmfm
  - @oakcask
