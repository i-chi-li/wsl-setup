#!/bin/sh
export DEBUG_PROC_CMDLINE="ds=nocloud;seedfrom=$(dirname $(realpath $0))/"
echo $DEBUG_PROC_CMDLINE
cloud-init init --local
cloud-init init
cloud-init modules --mode=config
cloud-init modules --mode=final
