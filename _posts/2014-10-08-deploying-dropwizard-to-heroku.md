---
layout: post
title: "Deploying Dropwizard 0.7.x to Heroku"
slug: deploying-dropwizard-to-heroku
description: 'Scalable RESTful services in Java: easier than you think'
image: assets/images/1.jpg
---

If you've ever deployed an app to Heroku, you know how easy it makes horizontal scaling, and if you've ever used Dropwizard, you know how easy it makes creating and maintaining RESTful services.

Combining these two technologies is actually pretty straightforward. With the advent of Dropwizard 0.7.x, there's a class explicitly for PaaS deployments: the [SimpleServerFactory](https://dropwizard.github.io/dropwizard/0.7.0/dropwizard-core/apidocs/io/dropwizard/server/SimpleServerFactory.html "SimpleServerFactory documentation").

Using this class is as easy as adding the following server settings to your config file.

{% highlight yaml %}
server:
  type: simple
  applicationContextPath: /
  adminContextPath: /admin
  connector:
    type: http
    port: 8080
{% endhighlight %}

Specifying the port as 8080 works fine locally, but there's one more trick for Heroku deployment. Heroku determines the port your application will use dynamically, storing the port as an environment variable at load. Hard coding the port in your config file won't work, so your Procfile will have to override the port specified in your config file.

{% highlight shell %}
web: java $JAVA_OPTS -Ddw.server.connector.port=$PORT -jar target/example*.jar server prod.yml
{% endhighlight %}

Here, we set a system property that Dropwizard picks up, overriding the value from the config file with the $PORT environment variable set by Heroku.

And that's it! There are other tricks to Dropwizard/Heroku integration (like creating a [DataSourceFactory](https://dropwizard.github.io/dropwizard/0.7.0/dropwizard-db/apidocs/io/dropwizard/db/DataSourceFactory.html "DataSourceFactory documentation") from Heroku's $DATABASE_URL variable) that I may cover in later posts.
