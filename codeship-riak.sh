#!/bin/bash
# Install a custom Riak version - http://www.basho.com/
#
# Include in your builds
# \curl -sSL riak.sh | bash -s
RIAK_VERSION=${RIAK_VERSION:="2.2.1"}
RIAK_MAJOR_VERSION=${RIAK_VERSION:0:1}
RIAK_DIR=${RIAK_DIR:="$HOME/riak"}
RIAK_WAIT_TIME=${RIAK_WAIT_TIME:="10"}
RIAK_START=${RIAK_START:="Y"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/riak-${RIAK_VERSION}.tar.gz"

mkdir -p "${RIAK_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "http://s3.amazonaws.com/downloads.basho.com/riak/${RIAK_MAJOR_VERSION}.0/${RIAK_VERSION}/riak-${RIAK_VERSION}.tar.gz"
tar zxvf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${RIAK_DIR}"
cd ${RIAK_DIR}
make rel

# Allow users to opt out of start Riak
if [ $RIAK_START = "Y" ]; then
	nohup bash -c "LC_ALL=C ${RIAK_DIR}/bin/riak start"
	sleep "${RIAK_WAIT_TIME}"
fi
