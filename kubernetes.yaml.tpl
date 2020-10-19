---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: custom-auth
  labels:
    app: custom-auth
spec:
  replicas: 1
  selector:
    matchLabels:
      app: custom-auth
  template:
    metadata:
      labels:
        app: custom-auth
    spec:
      containers:
      - name: custom-auth
        image: docker.io/tamu222i/custom-auth:COMMIT_SHA
        volumeMounts:
        - name: sajson
          mountPath: "/opt/app/instagram/secret"
        args: ["/usr/local/bin/node", "--inspect", "app.js"]
        workingDir: /opt/app/instagram
        ports:
        - containerPort: 8080
      volumes:
      - name: sajson
        secret:
          secretName: sajson
          items:
          - key: service-account.json
            path: service-account.json
