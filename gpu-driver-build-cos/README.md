# Cloud Build script for pre-building GPU kernel modules for COS

Use Cloud Build to schedule nVidia GPU kernel module builds on an interval (e.g. daily) so that the cached kernel modules are stored on GCS.  This speeds up GPU node joins as the driver modules do not need to be recompiled whenever a new node joins the cluster.

To run the build manually, use

```
gcloud builds submit
```

This build script will create a separate VPC network and zonal GKE cluster (in `us-west1-a` by default) with a single pre-emptible GPU node, execute the gpu driver build in a job, upload it to GCS, then tear the infrastructure down.  If the version of COS is updated, it will build and cache the copy corresponding to the kernel that the worker node runs.

Note that the [daemonset](../manifests/node/gpu-driver-cos.yaml) that installs the GPU kernel modules will pull down the cached copies from GCS and load them into the running kernel, provided the kernel the worker node is using has a copy of the kernel modules already built.  If none are available, the daemonset will build the kernel modules on its own as a fallback which can take up to 10 minutes.  Scheduling this build regularly can address unpredictable node join times affected by having to compile the GPU kernel module.