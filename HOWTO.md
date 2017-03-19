# How to set up HDP

## Create cluster

- E.g. 3 AWS nodes

## Install Salt on cluster

```
wget -O - https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
```

- Save the following file to /etc/apt/sources.list.d/saltstack.list:

```
deb http://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest trusty main
```

## Install Ambari on cluster

### Prep

- Put ambari-master entry into all /etc/hosts

### Run all the salt states

- Run repo on every node
- Run agent on every node
- Run server on master node

## Run ambari-setup

- Select JDK, accept defaults

## Create a blueprint

```
POST localhost:8080/api/v1/blueprints/multi-node-hdfs-yarn
```

```
{
  "host_groups" : [
    {
      "name" : "master",
      "components" : [
        {
          "name" : "NAMENODE"
        },
        {
          "name" : "SECONDARY_NAMENODE"
        },       
        {
          "name" : "RESOURCEMANAGER"
        },
        {
          "name" : "HISTORYSERVER"
        },
        {
          "name" : "ZOOKEEPER_SERVER"
        },
        {
          "name" : "APP_TIMELINE_SERVER"
        }
      ],
      "cardinality" : "1"
    },
    {
      "name" : "slaves",
      "components" : [
        {
          "name" : "DATANODE"
        },
        {
          "name" : "HDFS_CLIENT"
        },
        {
          "name" : "NODEMANAGER"
        },
        {
          "name" : "YARN_CLIENT"
        },
        {
          "name" : "MAPREDUCE2_CLIENT"
        },
        {
          "name" : "ZOOKEEPER_CLIENT"
        }
      ],
      "cardinality" : "1+"
    }
  ],
  "Blueprints" : {
    "blueprint_name" : "multi-node-hdfs-yarn",
    "stack_name" : "HDP",
    "stack_version" : "2.4"
  }
}
```

## Create cluster

```
POST localhost:8080/api/v1/clusters/MyThreeNodeCluster
```

```
{
  "blueprint" : "multi-node-hdfs-yarn",
  "default_password" : "my-super-secret-password",
  "host_groups" :[
    {
      "name" : "master", 
      "hosts" : [         
        {
          "fqdn" : "seuss-0"
        }
      ]
    },
    {
      "name" : "slaves", 
      "host_count" : 3,
      "host_predicate" : "Hosts/cpu_count=2"
    }
  ]
}
```

## Done!

![](done.jpg)
