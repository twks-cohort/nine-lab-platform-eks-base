1. Create a sample app along with the StorageClass and the PersistentVolumeClaim:
```
kubectl apply -f ebs-csi/test/dynamic-provisioning --recursive
```

2. Validate the volume was created and `volumeHandle` contains an EBS volumeID:
```
kubectl describe pv
```

3. Validate the pod successfully wrote data to the volume:
```
kubectl exec -it app cat /data/out.txt
```

4. Cleanup resources:
```
kubectl delete -f ebs-csi/test/dynamic-provisioning --recursive
```
