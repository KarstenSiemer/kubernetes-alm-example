#!/usr/bin/env bash

if type md5 >/dev/null 2>&1
then
  MD5=md5
else
  MD5=md5sum
fi

TMPDIR=$(mktemp -d)

prometheus_version="$(grep -Eo "([0-9]{1,}\.)+[0-9]{1,}" prometheus.tf)"

# shellcheck disable=SC2207
pre_run=($(cat crds/*.yaml | $MD5))

rm files/crds/prometheus/*
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm fetch prometheus-community/kube-prometheus-stack --version $prometheus_version

tar xvf kube-prometheus-stack-$prometheus_version.tgz --directory $TMPDIR --strip-components 4 kube-prometheus-stack/charts/crds/crds/
cp -r $TMPDIR/ ./files/crds/prometheus

rm -rf $TMPDIR
rm kube-prometheus-stack-$prometheus_version.tgz

# shellcheck disable=SC2207
post_run=($(cat ./files/crds/prometheus/*.yaml | $MD5))

# shellcheck disable=SC2128
if [ "${pre_run}" != "${post_run}" ]; then
  exit 1
fi
