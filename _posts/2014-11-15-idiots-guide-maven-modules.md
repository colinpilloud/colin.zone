---
layout: post
title: "An Idiot's Guide to Multi-Module Maven Projects"
description: "Dumbing it all the way down with Maven's best feature"
image: assets/images/3.jpg
---

To keep your Maven project from spiraling out of control, it helps to break it into modules: packages of code and resources that serve a singular purpose. However, this adds an extra element of dependency management, since you'll need to specify how exactly your modules depend on each other.


Fortunately, multi-module projects offer an elegant solution to this problem. Rather than bombard you with example POMs, I'll point you to [Dropwizard's source on GitHub](https://github.com/dropwizard/dropwizard).

The first thing to check out is the POM file in the root of the project. This is the <strong>parent POM</strong>, from which all other POMs inherit. Any properties, dependencies, or plugin configurations defined here will be passed onto the POM's children. This means any POM that declares a parent POM and points to dropwizard-parent will benefit from the configuration specified here.

You'll note the presence of the <strong>modules</strong> node. Every module listed here corresponds with a directory in the project root (at the same level as the parent POM). When you execute a Maven command from the project root (e.g. mvn clean package), that command ripples across all the different modules.

When you do execute a command, what Maven does next is pretty interesting. It passes all of the children POMs into the [Maven Reactor](http://maven.apache.org/guides/mini/guide-multiple-modules.html), which determines the proper order to build the projects (since building them in the wrong order could lead to dependency issues).

Another section of note in the parent POM is <strong>dependencyManagement</strong>. On the surface, this node looks like extra dependencies. What it actually does is provide a centralized location for you to define dependency versions, without mandating that all children use those dependencies. From the dependencyManagement section of the Dropwizard parent POM:

{% highlight xml %}
<dependencyManagement>
   <dependencies>
       <dependency>
           <groupId>com.fasterxml.jackson.core</groupId>
           <artifactId>jackson-annotations</artifactId>
           <version>${jackson.api.version}</version>
       </dependency>
       <!-- ... -->
   </dependencies>
</dependencyManagement>
{% endhighlight %}

This means that any child POM can declare a dependency on com.fasterxml.jackson.core without specifying a version, and it'll resolve to the version defined in the parent. It also means that any child POM that does <em>not</em> declare a dependency on com.fasterxml.jackson.core won't have it packaged, which is what would happen if this dependency was declared under the regular dependencies node in the parent POM.

To boil it down, here's the essentials:
<ul>
  <li>Multi-module projects have a parent POM in the project's root</li>
  <li>Child POMs inherit properties, dependencies, and plugin configurations from the parent</li>
  <li>The parent POM has a <strong>modules</strong> node, with entries mapping to directories in the root, with each directory containing its own Maven project</li>
  <li>Maven commands executed at the root ripple across all the listed modules</li>
  <li>Maven's Reactor figures out the right order in which to build your projects</li>
</ul>