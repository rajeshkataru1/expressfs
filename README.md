# expressfs is a Simple Static file server over http
You can use it to upload and download files

# Running expressfs locally 
1. You need to have nodejs installed
2. Clone repository
3. Run: 
    ``node app.js``


# Running expressfs in docker container 

1. Pull the image locally
 
   Pull this container with the following Podman command:
   ```bash
      podman pull quay.io/istrate/expressfs:1.0.0 
   ```
   Pull this container with the following Docker command:
   ```bash
      docker pull quay.io/istrate/expressfs:1.0.0 
   ```
2. Run image in container
   ```bash
      podman run -d -ti -p 8080:8080 quay.io/istrate/expressfs:1.0.0
   ```	 

# Deploy in OpenShift 

Here’s a straightforward set of steps to deploy expressfs on OpenShift using the GitHub repo you linked:

⸻

Step 1: Create a new OpenShift Project

Use the web console or CLI:

oc new-project expressfs



Step 2: Deploy from Git (using web console)

This approach works well:
	
 1.	Switch to Developer view → click + Add → select From Git.
	
 2.	Git Repo URL: https://github.com/istrate/expressfs
	
 3.	Application Name: expressfs
	
 4.	Choose the deployment strategy (defaults are fine).
	
 5.	Click Create—OpenShift will build and deploy the app, and auto-generate a Route for access.  ￼ ￼

6. clone the git repo
   
git clone https://github.com/rajeshkataru1/expressfs

cd expressfs
8. Rub below commands

oc new-build --name=expressfs --binary --strategy=docker -n expressfs

oc start-build expressfs --from-dir=. --follow -n expressfs


Step 3: Verify and Use
	1.	Check status:

oc get pods,svc,route -n expressfs


	2.	When ready, grab the App URL from the Route and open it. You’ll land on the expressfs UI where you can upload/download files. ()



Summary

Step	Action
1	Create a project (expressfs)
2	Deploy via From Git or upload YAML
3	Expose the app with service/route
4	Access via Route and test file uploads


⸻

Alternative way:
Import below YAML definition. It will create a Deployment, Service and Route in `expressfs` project. Route will be automatically generated. Change the values as per your need. Involved resources can be separately created as well. 
```yaml
---
kind: Deployment
apiVersion: apps/v1
metadata:  
  name: expressfs     
  namespace: expressfs  
spec:
  replicas: 1
  selector:
    matchLabels:
      app: expressfs
  template:
    metadata:     
      labels:
        app: expressfs
        deploymentconfig: expressfs
    spec:
      containers:
        - name: expressfs
          image: quay.io/istrate/expressfs:1.0.0
          ports:
            - containerPort: 8080
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          imagePullPolicy: Always
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
      dnsPolicy: ClusterFirst
      securityContext: {}
      schedulerName: default-scheduler
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 25%
  revisionHistoryLimit: 10
  progressDeadlineSeconds: 600
---
apiVersion: v1
kind: Service
metadata:
  name: expressfs
  namespace: expressfs
spec:
  selector:
    app: expressfs
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
---
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: expressfs
  namespace: expressfs
spec:
  path: /
  to:
    kind: Service
    name: expressfs
  port:
    targetPort: 8080
```


Check status:
oc get pods,svc,route -n expressfs
