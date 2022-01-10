1. Create a sample app along with the StorageClass and the PersistentVolumeClaim:
```
kubectl apply -f ebs-csi/test/dynamic-provisioning --recursive
```
wait 30 sec

2. Validate the volume was created and `volumeHandle` contains an EBS volumeID:
```
kubectl describe pv
```

3. Validate the pod successfully wrote data to the volume:
```
kubectl exec -it app cat /data/out.txt
```

4. Cleanup resources (or go to perform resizing test):
```
kubectl delete -f ebs-csi/test/dynamic-provisioning --recursive
```

### bats test

bats test/ebs-csi/dynamic-provisioning
