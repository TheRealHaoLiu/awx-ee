ansible-builder create
mkdir build_data_dir
mv context build_data_dir
tar -cf - build_data_dir/* | gzip -9 | kubectl run kaniko-debug \
--rm --stdin=true \
--image=gcr.io/kaniko-project/executor:debug --restart=Never \
--overrides='{
  "apiVersion": "v1",
  "spec": {
    "containers": [
      {
        "name": "kaniko",
        "image": "gcr.io/kaniko-project/executor:debug",
        "stdin": true,
        "stdinOnce": true,
        "command": [
          "/busybox/sleep",
          "infinity"
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
        "secret": {
          "secretName": "haoliu-pull-secret"
        }
      }
    ]
  }
}'
