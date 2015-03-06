#!/bin/bash
# Source env variables including iojs version
. /opt/elasticbeanstalk/env.vars

function error_exit
{
  eventHelper.py --msg "$1" --severity ERROR
  exit $2
}

# Redirect all output to cfn-init
exec >>/var/log/cfn-init.log  2>&1

# Download and extract desired iojs.js version
echo "checking iojs..."
OUT=$( [ ! -d "/opt/elasticbeanstalk/node-install" ] && echo "trying to install io.js $IOJS_VER"   && mkdir /opt/elasticbeanstalk/node-install ; cd /opt/elasticbeanstalk/node-install/ && \
  wget -nc http://iojs.org/dist/v$IOJS_VER/iojs-v$IOJS_VER-linux-$ARCH.tar.gz && \
  tar --skip-old-files -xzpf iojs-v$IOJS_VER-linux-$ARCH.tar.gz) || error_exit "Failed to UPDATE node version. $OUT" $?.
echo $OUT

# Make sure iojs/node binaries can be found globally
if [ ! -L /usr/bin/node ]; then
  ln -s /opt/elasticbeanstalk/node-install/iojs-v$IOJS_VER-linux-$ARCH/bin/node /usr/bin/node
fi

if [ ! -L /usr/bin/npm ]; then
ln -s /opt/elasticbeanstalk/node-install/iojs-v$IOJS_VER-linux-$ARCH/bin/npm /usr/bin/npm
fi
