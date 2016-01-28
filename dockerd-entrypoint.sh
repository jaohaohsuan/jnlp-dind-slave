#!/bin/sh
set -e

set -- docker daemon \
	--host=unix:///var/run/docker.sock \
	--host=tcp://0.0.0.0:2375 \
	--storage-driver=vfs

# if -tunnel is not provided try env vars
if [[ "$@" != *"-tunnel "* ]]; then
	if [[ ! -z "$JENKINS_TUNNEL" ]]; then
		TUNNEL="-tunnel $JENKINS_TUNNEL"		
	fi
fi

if [[ ! -z "$JENKINS_URL" ]]; then
	URL="-url $JENKINS_URL"
fi

exec java $JAVA_OPTS -cp /usr/share/jenkins/slave.jar hudson.remoting.jnlp.Main -headless $TUNNEL $URL

exec "$@"
