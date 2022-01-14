#!/bin/bash

conatiner_IP=$(tail -n1 /etc/hosts | awk '{print $1}')

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

domain
