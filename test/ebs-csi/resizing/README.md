# Note

eks addon `aws-ebs-csi-driver` is still at v1.2 for the csi-controller. Later controller versions support resizing but until the eks-addon is brought up to those versions this implementation does not yet support.  

1. Expand the volume size by increasing the capacity in PVC's `spec.resources.requests.storage`:
```sh
kubectl apply -f ebs-csi/test/resizing/resize-claim-test.yaml
```


2. Verify that both the persistence volume and persistence volume claim are resized:
```sh
kubectl get pv
kubectl get pvc
```
You should see that both should have the new value relfected in the capacity fields.

3. Verify that the application is continuously running without any interruption:
```sh
kubectl exec -it app cat /data/out.txt
```

4. Cleanup resources:
```
kubectl delete -f ebs-csi/test/dynamic-provisioning --recursive
```

### bats test

bats test/ebs-csi/resizing
