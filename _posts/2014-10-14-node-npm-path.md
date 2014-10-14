---
layout: post
title: "node, npm, and $PATH"
quote: 'Environment configuration for npm after installing'
image: /media/2014-10-14-node-npm-path/cover.jpg
comments: true
---

I recently started playing with Google's [web-starter-kit](https://developers.google.com/web/starter-kit/index "Web Starter Kit &ndash; Web Fundamentals"), intending to build upon its boilerplate for a personal project.

After downloading and extracting the zip, I went to install the dependencies using npm. I'd already had a previous version of node (and by association npm) installed, so as expected, running <strong>npm install</strong> successfully installed all the dependencies. 

However, when I went to run the <strong>gulp serve</strong> command to compile assets and serve the site locally, my shell couldn't find the <strong>gulp</strong> executable.

After a quick search, I realized what exactly running <strong>npm install</strong> did for me. According to the [CLI docs](https://www.npmjs.org/doc/cli/npm-install.html "npm-install"), <strong>npm</strong> has two methods of installing packages &ndash; without any flags, it defaults to installing them locally, i.e. within the <strong>node_modules</strong> folder. If you actually do want to install it globally, you can add the <strong>-g</strong> flag.

That's well and good, but where exactly are the executables? They're <em>inside the computer</em>.

![Zoolander Baffled By Computer](/media/2014-10-14-node-npm-path/zoolander.jpg)

More specifically, they're inside the node_modules folder, nested under <strong>.bin</strong>. You can append that to your $PATH environment variable like so:

{% highlight shell %}
export PATH=./node_modules/.bin:$PATH
{% endhighlight %}

And of course, you can make that permanent by adding that to your shell's profile.