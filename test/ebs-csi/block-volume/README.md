1. Create a sample app along with the StorageClass and the PersistentVolumeClaim:
```
kubectl apply -f ebs-csi/test/block-volume --recursive
```

2. Verify that pod is running:
```sh
$ kubectl get pods
NAME   READY   STATUS    RESTARTS   AGE
app    1/1     Running   0          16m
```

3. Verify the device node is mounted inside the container:
```sh
$ kubectl exec -ti app -- ls -al /dev/xvda
brw-rw----    1 root     disk      202, 23296 Mar 12 04:23 /dev/xvda
```

4. Write to the device using:
```sh
dd if=/dev/zero of=/dev/xvda bs=1024k count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.0492386 s, 2.1 GB/s
```

5. Cleanup resources:
```
kubectl delete -f ebs-csi/test/block-volume --recursive
```
