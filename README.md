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

## Consideration

- Caused by [this bug](https://bugs.ruby-lang.org/issues/16288)?
  - There is [a similar output](https://github.com/ruby-concurrency/concurrent-ruby/issues/808#issuecomment-534944201).
- [This commit](https://github.com/mongodb/mongo-ruby-driver/commit/485ee7b24a1d34b3ea52b998dfd4dcc25454b6a5) causes the segfault.
  - The segfault does not happen if [this line](https://github.com/mongodb/mongo-ruby-driver/commit/485ee7b24a1d34b3ea52b998dfd4dcc25454b6a5#diff-10c9bc0ac2ab9e61b772cab992027054809ec5e71268a32541e374a7e7b5af9aR70) is commented out.

## Special Thanks

- https://github.com/bitnami/bitnami-docker-mongodb-sharded
- My Colleagues (ABC order)
  - @motobrew
  - @mtsmfm
  - @oakcask
