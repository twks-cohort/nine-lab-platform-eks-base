apiVersion: v1
preferences: {}
kind: Config

clusters:
- cluster:
    server: ${cluster_endpoint}
    certificate-authority-data: ${cluster_certificate_authority_data}
  name: ${kubeconfig_name}

contexts:
- context:
    cluster: ${kubeconfig_name}
    user: ${kubeconfig_name}
  name: ${kubeconfig_name}

current-context: ${kubeconfig_name}

users:
- name: ${kubeconfig_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${cluster_name}"
        - --role
        - arn:aws:iam::${aws_account_id}:role/${aws_assume_role}
