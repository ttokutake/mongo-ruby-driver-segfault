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
... (snip)
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

## Backtrace by GDB

```
$ docker-compose run ruby /bin/bash

> apt update
> apt install gdb
> dns_local_ip_address=`ping -c 1 dns.local | head -1 | sed -E 's/.*\(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)\).*/\1/'`
> echo -e "nameserver ${dns_local_ip_address}\n$(cat /etc/resolv.conf)" > /etc/resolv.conf
> gdb --args ruby main.rb

(gdb) run
Starting program: /usr/local/bin/ruby main.rb
warning: Error disabling address space randomization: Operation not permitted
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[New Thread 0x7ff9231de700 (LWP 351)]
[New Thread 0x7ff9230a6700 (LWP 352)]
Fetching gem metadata from https://rubygems.org/.[New Thread 0x7ff922fa5700 (LWP 353)]
[New Thread 0x7ff922ea4700 (LWP 354)]
[New Thread 0x7ff922da3700 (LWP 355)]
[New Thread 0x7ff922ca2700 (LWP 356)]
[New Thread 0x7ff922ba1700 (LWP 357)]
[New Thread 0x7ff922aa0700 (LWP 358)]
[New Thread 0x7ff92299f700 (LWP 359)]
[New Thread 0x7ff92289e700 (LWP 360)]
[New Thread 0x7ff92279d700 (LWP 361)]
[New Thread 0x7ff92269c700 (LWP 362)]
[New Thread 0x7ff92259b700 (LWP 363)]
[New Thread 0x7ff92249a700 (LWP 364)]
[New Thread 0x7ff922399700 (LWP 365)]
[New Thread 0x7ff922298700 (LWP 366)]
[New Thread 0x7ff922197700 (LWP 367)]
[New Thread 0x7ff922096700 (LWP 368)]
[New Thread 0x7ff921f95700 (LWP 369)]
[New Thread 0x7ff921e94700 (LWP 370)]
[New Thread 0x7ff921d93700 (LWP 371)]
[New Thread 0x7ff921c92700 (LWP 372)]
[New Thread 0x7ff921b91700 (LWP 373)]
[New Thread 0x7ff921a90700 (LWP 374)]
[New Thread 0x7ff92198f700 (LWP 375)]
[New Thread 0x7ff92188e700 (LWP 376)]
.[New Thread 0x7ff92178d700 (LWP 377)]
.[New Thread 0x7ff92168c700 (LWP 378)]
[New Thread 0x7ff92158b700 (LWP 379)]
[New Thread 0x7ff92148a700 (LWP 380)]
[New Thread 0x7ff921389700 (LWP 381)]
[New Thread 0x7ff921288700 (LWP 382)]
[New Thread 0x7ff921187700 (LWP 383)]
.[New Thread 0x7ff921086700 (LWP 384)]
[New Thread 0x7ff920f85700 (LWP 385)]
[New Thread 0x7ff920e84700 (LWP 386)]
[New Thread 0x7ff920d83700 (LWP 387)]
[New Thread 0x7ff920c82700 (LWP 388)]
[New Thread 0x7ff920b81700 (LWP 389)]
....
Resolving dependencies...
... (snip)
D, [2020-11-27T04:51:17.760935 #347] DEBUG -- : MONGODB | [14] mongodb-sharded.cluster.local:27017 | admin.endSessions | SUCCEEDED | 0.000s
corrupted double-linked list

Thread 42 "background_thr*" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ff921c92700 (LWP 437)]
0x00007ff926733078 in thread_start_func_2 (th=0x55883fdedb40, stack_start=<optimized out>) at thread.c:776
776	thread.c: No such file or directory.
(gdb) bt
#0  0x00007ff926733078 in thread_start_func_2 (th=0x55883fdedb40, stack_start=<optimized out>) at thread.c:776
#1  0x00007ff926733524 in thread_start_func_1 (th_ptr=<optimized out>) at thread_pthread.c:1030
#2  0x00007ff9262edfa3 in start_thread (arg=<optimized out>) at pthread_create.c:486
#3  0x00007ff925fcd4cf in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:95
```

## Special Thanks

- https://github.com/bitnami/bitnami-docker-mongodb-sharded
- My Colleagues (ABC order)
  - @motobrew
  - @mtsmfm
  - @oakcask
