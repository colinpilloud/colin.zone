---
layout: post
title: "node.js app using Web Starter Kit and Heroku"
quote: "Using a custom buildpack to deploy node-WSK apps to Heroku"
image: /media/2014-12-26-node-web-starter-kit-heroku/cover.jpg
comments: true
---

While attempting to deploy a node-backed application to Heroku that was bootstrapped using [WSK](https://developers.google.com/web/starter-kit/), I ran into a few issues. My initial googling didn't quite help, mostly because I was searching for the wrong thing. [This answer from Heroku](https://discussion.heroku.com/t/google-web-starter-kit-webapp-heroku-application-error-fundamental-issue-of-understanding-or-bug/691/3?u=earl977) put me on the wrong track, thinking I'd have to build the site locally, then deploy the generated dist/ folder with the Harp buildback.

That seemed out of sorts with not only my usage of node, but also Heroku's git deployment methodology. I'd be committing generated files to one remote, but not another, and while that's doable, it didn't seem right. Some more searching brought me to [this buildpack](https://github.com/9elements/heroku-buildpack-nodejs-gulp-haml-sass-compass). As they say in the old folks home: bingo. Since WSK uses gulp and sass, this buildpack does everything we need to deploy to Heroku.

Here's a (mostly complete) list of things you'll need to do.

### 1. Add the buildpack to your project

{% highlight shell %}
heroku config:add BUILDPACK_URL=https://github.com/9elements/heroku-buildpack-nodejs-gulp-haml-sass-compass.git
{% endhighlight %}

### 2. Add a "heroku" task in your gulpfile.js

This is the task that the buildpack will call.

{% highlight javascript %}
gulp.task('heroku', ['default']);
{% endhighlight %}

Note: I made mine call the default task, but you can customize the behavior here if desired.

### 3. Modify your node application to serve up the dist/ folder 

Express will nicely accomplish that for us, but don't forget to add Express as a dependency!
{% highlight javascript %}
var express = require('express');
var app = express();

app.use(express.static(__dirname + "/dist"));

var port = process.env.PORT || 3000;
app.listen(port);
{% endhighlight %}

This will grab the environment variable for the port when deployed to Heroku, or it'll default to 3000. Change it if you want, see if I care.

### 4. Add a startup script to your package.json

{% highlight javascript %}
{
  // ...
  "scripts": {
    "start": "node server.js", // or whatever your application is named
  }
  // ...
}
{% endhighlight %}

### 5. Add a Procfile

{% highlight shell %}
web: npm start
{% endhighlight %}

Nothing crazy here, just delegating to the npm start script declared above.

And that's it! Now when you push to your Heroku remote, the buildpack will kickoff the gulp task you've specified, which should build your app into dist. Then, when Heroku starts your application, it'll execute your node file, which should be serving files out of dist if configured correctly.

One thing I plan on taking a look at is using WSK's browser sync locally while simultaneously running the main node application (in my case I have a couple custom request handlers). This should be easy in theory, but if it proves more complicated expect another blog post.