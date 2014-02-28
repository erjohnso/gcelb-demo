## Google Compute Engine Load-Balancer Demo

This repo is a place to park my GCELB demo code. It requires a bit of
customization for each demo, but I've used it with Puppet and SaltStack.

General idea is to create 4 GCE `Debian-7` instances, install these files
on each instance, put them behind a GCELB, and then hit the LB's public IP
with your browser to test. The page to be fetched again (without caching)
and will flip between the 4 instances (each with it's own Google primary
color).

For this demo to truly work dynamically, it is ideal for each `index.html`
page's title be set to `<title>instance_shortname</title>`. If you use the
actual shortnames of `myinstance{1..4}`, then the `if-else` javascript
statements do not need to be updated.

As an example, during the SaltConf demo, when I dropped down the `index.html`
file, I used `<title>{{ grains.id }}</title>` and as the file was being
written to the instance, the jinja2 processing replace `{{ grains.id }}`
with that instance's short hostname.

The actual title-element for the `index.html` page is @MY_INSTANCE_NAME@
and a sed command can be used to replace that with the local instance's
short hostname. For example,

```sh
NAME=$(hostname -s)
sed -i "s|@MY_INSTANCE_NAME@|$NAME|" /var/www/index.html
```

### Install

1. Make sure your GCE `network` has `tcp:80` open
1. Use some tool-specific (demo) automated way to spin up 4 `Debian-7`
   instances, preferably two per zone in the same region.
1. When the instances are created, install apache2 overwrite the package's
   `/etc/apache2/apache2.conf` file with this custom `apache2.conf` file.
1. Make sure that the installation of apache also enables `mod_headers`
   (e.g. `/etc/apache2/mods-enabled`). The custom `apache2.conf` includes
   `mod_header` directives to disable client-side caching with custom
   headers (lines 264-272).
1. Next, copy over the `index.html` and `demo.css` files to apache's root
   directory, typically `/var/www`.
1. Create the GCELB and place all 4 instances in the GCELB's `TargetPool`.
   Set its `ForwardingRule` to forward `tcp:80` traffic to the `TargetPool`.

### Test / Usage

1. Point your browser to `http://a.b.c.d` and you should see a page served
   from one of your instances.
1. If all goes well, the javascript `location.reload(true)` function should
   be triggered onLoad and you'll see the browser flip between all four
   instances with separate Google colors.

### Troubleshooting

1. Check the HTTP headers to ensure that client-side caching is indeed
   disabled. Using `curl -I http://a.b.c.d`, you should see headers like
   `Cache-Control: "max-age=0, no-cache, no-store, must-revalidate"`,
   `Pragma: "no-cache"`, and  `Expires: "Wed, 11 Jan 2010 05:00:00 GMT"`.
1. If your instance's background color is white and you are dynamically
   updating the `index.html` title, make sure the javascript code's
   `if-else` block is using the correct instance names for setting the page
   background color. The default is to use `myinstance{1..4}` for the
   instance names.

