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

## Results

```
Fetching gem metadata from https://rubygems.org/........
Resolving dependencies...
Fetching bson 4.11.1
Installing bson 4.11.1 with native extensions
Using bundler 1.17.2
Fetching mongo 2.11.0
Installing mongo 2.11.0
D, [2020-11-27T00:20:31.035863 #11] DEBUG -- : MONGODB | EVENT: #<TopologyOpening topology=Unknown[]>
...
D, [2020-11-27T00:20:31.145112 #11] DEBUG -- : MONGODB | [14] mongodb-sharded.cluster.local:27017 | admin.endSessions | SUCCEEDED | 0.000s
[BUG] Segmentation fault at 0x0000000000000050
ruby 2.6.6p146 (2020-03-31 revision 67876) [x86_64-linux]

-- Control frame information -----------------------------------------------
c:0001 p:---- s:0003 e:000002 (none) [FINISH]


-- Machine register context ------------------------------------------------
 RIP: 0x00007f52358f4078 RBP: 0x00007f5230b4fdd0 RSP: 0x00007f5230b4fc90
 RAX: 0x0000000000000000 RBX: 0x0000563b4b746370 RCX: 0x0000563b44ad4158
 RDX: 0x0000563b44ad4570 RDI: 0x0000563b4b8bd318 RSI: 0x0000563b44ad4020
  R8: 0x0000000000000011  R9: 0x0000000000000000 R10: 0x0000563b4a8dc050
 R11: 0x0000000000000003 R12: 0x0000000000000009 R13: 0x0000563b44b7f630
 R14: 0x0000563b46ce6ac0 R15: 0x0000563b498440d8 EFL: 0x0000000000010297

-- C level backtrace information -------------------------------------------
corrupted double-linked list
Aborted
```

- Ruby 2.6.6p146 (2020-03-31 revision 67876) [x86_64-linux]
  - mongo-ruby-driver 2.10.5: OK
  - mongo-ruby-driver 2.11.0: Segfault
  - mongo-ruby-driver 2.13.1: Segfault
- Ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-linux]
  - mongo-ruby-driver 2.10.5: OK
  - mongo-ruby-driver 2.11.0: Segfault
  - mongo-ruby-driver 2.13.1: Segfault
- Ruby 3.0.0preview1 (2020-09-25 master 0096d2b895) [x86_64-linux]
  - mongo-ruby-driver 2.13.1: OK

## Consideration

- Caused by [this bug](https://bugs.ruby-lang.org/issues/16288)?
  - There is [a similar result](https://github.com/ruby-concurrency/concurrent-ruby/issues/808#issuecomment-534944201).
- [This commit](https://github.com/mongodb/mongo-ruby-driver/commit/485ee7b24a1d34b3ea52b998dfd4dcc25454b6a5) has caused the segfault.
  - It does not happen if [this line](https://github.com/mongodb/mongo-ruby-driver/commit/485ee7b24a1d34b3ea52b998dfd4dcc25454b6a5#diff-10c9bc0ac2ab9e61b772cab992027054809ec5e71268a32541e374a7e7b5af9aR70) is commented out.

## Special Thanks

- https://github.com/bitnami/bitnami-docker-mongodb-sharded
- My Colleagues (ABC order)
  - @motobrew
  - @mtsmfm
  - @oakcask
