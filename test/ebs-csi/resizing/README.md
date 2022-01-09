1. Deploy the example:
```sh
kubectl apply -f ebs-csi/test/resizing/create-claim.yaml
``` 

2. Verify the volume is created and Pod is running:
```sh
kubectl get pv
kubectl get po app
```

3. Expand the volume size by increasing the capacity in PVC's `spec.resources.requests.storage`:
```sh
kubectl apply -f ebs-csi/test/resizing/resize-claim-test.yaml
```


4. Verify that both the persistence volume and persistence volume claim are resized:
```sh
kubectl get pv
kubectl get pvc
```
You should see that both should have the new value relfected in the capacity fields.

5. Verify that the application is continuously running without any interruption:
```sh
kubectl exec -it app cat /data/out.txt
```

6. Cleanup resources:
```
kubectl delete -f ebs-csi/test/resizing/create-claim.yaml
```
