Nick Brandaleone
August 2019

This kubernetes scheduler is simply an updated version of:
https://github.com/agonzalezro/escheduler
The original blog post is here: http://agonzalezro.github.io/scheduling-your-kubernetes-pods-with-elixir.html

My blog is located at https://nickaws.net/
This post is under "custom schedulers"

Build using mix. Does require Erlang on machine.
Elixir is embedded in script, so not directly needed.

$ MIX_ENV=prod mix escript.build
$ ./escheduler 
-----------------------------------------------------

{e,}scheduler
=============

A Elixir toy scheduler for Kubernetes. It will randomly schedule your pod in some node.

This project is just a POC to test what [Kelsey](https://twitter.com/kelseyhightower) taught us on [this awesome talk](https://skillsmatter.com/skillscasts/7897-keynote-get-your-ship-together-containers-are-here-to-stay).

Prereqs
-------

Define an annotated pod with the following spec:

    schedulerName: escheduler

In case you don't know how to do it, check the `examples/` folder.

And create it:

    kubectl create -f examples/pod-demo.yaml

If we now get the list of pods we will see it as pending:

    kubectl get pods
    NAME      READY     STATUS    RESTARTS   AGE
    custom    0/1       Pending   0          44s
    
Now let the magic begin!

Usage
-----

We need a kubeproxy running to avoid auth problems and have an easy setup-able local communication with our cluster:

    kubectl proxy
    Starting to serve on 127.0.0.1:8001

If you are not familiarized with Elixir you can take a look to [mix documentation](http://elixir-lang.org/docs/stable/mix/Mix.html), but in a nutshell:

    mix escript.build
    
Will generate a executable called `escheduler`. Let the magic happen:

    ./escheduler
    custom pod scheduled in gke-cluster-1-default-pool-f979b5a2-oqb1    

If you don't trust me you can check again:

    kubectl get pods
    NAME      READY     STATUS    RESTARTS   AGE
    custom    1/1       Running   0          1m
