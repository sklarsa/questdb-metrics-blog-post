# QuestDB Kubernetes Metrics Example

This repo is a working demo of how to process infrastructure metrics in Kubernetes using QuestDB.

## Requirements
- [kind](https://kind.sigs.k8s.io/) (requires either [docker](https://www.docker.com/get-started/) or [podman](https://podman.io/))
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [helm](https://helm.sh/)

## Instructions

To run the example, execute the following commands:

```bash
git clone https://github.com/sklarsa/questdb-metrics-blog-post.git
cd questdb-metrics-blog-post
./run.sh
```

After a few minutes, all pods should be in the `READY` state and you should be able to open up a port-forward to the QuestDB frontend:

```bash
kubectl port-forward service/questdb -n questdb 9000:9000
```

From here, you can navigate to http://localhost:9000 and explore the metrics that are being ingested into QuestDB.
The default Prometheus scrape interval is 30 seconds, so there might not be a ton of data in there, but you should see a list of tables,
one per each metric that we are collecting.

Once you're done, you can clean up the entire experiment by deleting the cluster:
```bash
./cleanup.sh
```
