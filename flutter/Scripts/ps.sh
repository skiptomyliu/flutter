#!/bin/sh

#  ps.sh
#  flutter
#
#  Created by Dean Liu on 2/11/15.
#  Copyright (c) 2015 dragonfly. All rights reserved.

ps -p $1 -o command | sed 1d