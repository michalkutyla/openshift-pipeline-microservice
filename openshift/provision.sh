#!/bin/bash
################################################################################
# Prvisioning script to deploy to OpenShift environment            #
# Assumes user logged in to OpenShift (oc login)                   #
# and all openshift projects have been created                   #
################################################################################
ARG_CICD_PROJECT=$1
ARG_DEVELOPMENT_PROJECT=$2
ARG_TEST_PROJECT=$3
ARG_PROD_PROJECT=$4
ARG_PATH_TO_PRIVATE_KEY=$5

#oc secrets new buildsecret ssh-privatekey=$ARG_PATH_TO_PRIVATE_KEY -n $ARG_DEVELOPMENT_PROJECT 
oc process -f dummy-service-build-template.yaml | oc create -n $ARG_DEVELOPMENT_PROJECT -f -

oc process -f dummy-service-deployment-template.yaml --param=NAMESPACE=$ARG_DEVELOPMENT_PROJECT | oc create -n $ARG_DEVELOPMENT_PROJECT -f -
oc process -f dummy-service-deployment-template.yaml --param=NAMESPACE=$ARG_TEST_PROJECT | oc create -n $ARG_TEST_PROJECT -f -
oc process -f dummy-service-bluegreen-template.yaml --param=NAMESPACE=$ARG_PROD_PROJECT | oc create -n $ARG_PROD_PROJECT -f -

oc process -f dummy-service-pipeline.yaml --param=DEV_PROJECT=$ARG_DEVELOPMENT_PROJECT --param=TEST_PROJECT=$ARG_TEST_PROJECT  --param=PROD_PROJECT=$ARG_PROD_PROJECT | oc create -n $ARG_CICD_PROJECT -f -

oc policy add-role-to-user edit system:serviceaccount:$ARG_CICD_PROJECT:jenkins -n $ARG_DEVELOPMENT_PROJECT
oc policy add-role-to-user edit system:serviceaccount:$ARG_CICD_PROJECT:jenkins -n $ARG_TEST_PROJECT
oc policy add-role-to-user edit system:serviceaccount:$ARG_CICD_PROJECT:jenkins -n $ARG_PROD_PROJECT
