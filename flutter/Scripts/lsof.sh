#!/bin/sh

#  lsof.sh
#  flutter
#
#  Created by Dean Liu on 2/3/15.
#  Copyright (c) 2015 dragonfly. All rights reserved.

lsof -n -P -iTCP -sTCP:ESTABLISHED | awk '{print $1"~"$2"~"$3"~"$5"~"$8"~"$9 }' | sed 1d