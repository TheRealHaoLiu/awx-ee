ansible-builder create
tar -cf - context/* | gzip -9 | kubectl run kaniko-push \
--rm --stdin=true \
--image=gcr.io/kaniko-project/executor:latest --restart=Never \
--overrides='{
  "apiVersion": "v1",
  "spec": {
    "containers": [
      {
        "name": "kaniko",
        "image": "gcr.io/kaniko-project/executor:latest",
        "stdin": true,
        "stdinOnce": true,
        "args": [
          "--dockerfile=Containerfile",
          "--context=tar://stdin",
          "--context-sub-path=context",
          "--destination=quay.io/haoliu/awx-ee:build-with-kaniko"
        ],
        "volumeMounts": [
          {
            "name": "docker-config",
            "mountPath": "/kaniko/.docker/"
          }
        ]
      }
    ],
    "volumes": [
      {
        "name": "docker-config",
        "configMap": {
          "name": "docker-config"
        }
      }
    ]
  }
}'
