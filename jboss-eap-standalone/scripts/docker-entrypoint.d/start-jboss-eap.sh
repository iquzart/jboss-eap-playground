#!/bin/bash

conatiner_IP=$(tail -n1 /etc/hosts | awk '{print $1}')

# Standalone profile
standalone () {
    echo "Initialising standalone configs"
    if [[ "$JBOSS_PROFILE_NAME" == *"ha"* ]];then
        # Start the jboss admin-only mode
        $JBOSS_HOME/bin/standalone.sh -c $JBOSS_PROFILE_NAME --admin-only 2>&1 1>/dev/null &
        sleep 5
        # Execute cli scripts
        for f in `ls scripts/jboss-cli/*-standalone-*.cli | sort`
            do 
                echo "Executing CLI script: " $f
                $JBOSS_HOME/bin/jboss-cli.sh -c --file=$f
        done
        # Shutdown jboss admin-only mode
        $JBOSS_HOME/bin/jboss-cli.sh -c ":shutdown" 2>&1 1>/dev/null
        # Temp setup Change this to cli
        sed -i 's/name="jgroups-tcp" interface="private" port="7600"/name="jgroups-tcp" interface="public" port="7600"/g' $JBOSS_HOME/standalone/configuration/$JBOSS_PROFILE_NAME
        sleep 5
    else
        echo "Ignoring the HA configurations"
    fi

    echo 'JAVA_OPTS="$JAVA_OPTS -Djboss.tx.node.id=$HOSTNAME"' >> $JBOSS_HOME/bin/standalone.conf
    echo 'JAVA_OPTS="$JAVA_OPTS -Djboss.node.name=$HOSTNAME"' >> $JBOSS_HOME/bin/standalone.conf
    echo "Configuration completed."
    echo "Starting jboss with $JBOSS_PROFILE_NAME profile..."
    $JBOSS_HOME/bin/standalone.sh -c $JBOSS_PROFILE_NAME -Djboss.bind.address=$conatiner_IP -Djboss.bind.address.management=$conatiner_IP
}


domain () {
    echo "Initialising domain configs"
    $JBOSS_HOME/bin/add-user.sh ${JBOSS_CLUSTER_USER} ${JBOSS_CLUSTER_USER_PASSWORD} --silent

    echo "Starting jboss with $JBOSS_PROFILE_NAME profile..."
    if [[ "$JBOSS_PROFILE_NAME" =~ ^host-master* ]]; then
        # Start Master Node
        $JBOSS_HOME/bin/domain.sh --host-config=$JBOSS_PROFILE_NAME -Djboss.bind.address=$conatiner_IP -Djboss.bind.address.management=$conatiner_IP
    elif [[ "$JBOSS_PROFILE_NAME" =~ ^host-slave* ]]; then
        echo "Configuration completed. Waiting for master to start"
        # Wait for Master node to start
        sleep 20
        # Start Slave Node
        $JBOSS_HOME/bin/domain.sh --host-config=$JBOSS_PROFILE_NAME -Djboss.bind.address=$conatiner_IP -Djboss.bind.address.management=$conatiner_IP -Djboss.domain.master.address="jboss-eap-node-dc"
    fi
}

if [[ "$JBOSS_PROFILE_NAME" =~ ^standalone.* ]]; then
    standalone
elif [[ "$JBOSS_PROFILE_NAME" =~ ^host.* ]]; then
    domain
fi