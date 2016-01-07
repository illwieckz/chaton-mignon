Chaton Mignon
=============


(-̂.-̂) ron-ron


About
-----

This code is a proof of concept I made years ago (when common Linux desktops were able to run _[Desktop Entries](http://standards.freedesktop.org/desktop-entry-spec/latest/)_ without requiring execution bit). The first iteration was around 2007. I added afterward a convenient way to embed the malicious desktop file inside a tar archive that keeps the execution bit, so the user who downloads the file can run it right after extraction. The _"Chaton Mignon"_ name means _"Cute Cat"_, and was taken as an example of widely recognized appealing content an user wants to display.

So this is how it works:

1. One Gziped Tarball ships a malicious Desktop Entry;
2. That Desktop Entry mimics a normal document appearence (icon, name…);
3. That Desktop Entry decodes some embedded data and pass them to a Shell interperter;
4. The Shell script executes some arbitrary malicious code (here a D-Bus notification sender written in Python Programming Language);
5. The Shell script warns the administrator logging someone let the cat come in;
6. The Shell script writes down a regular document with name and format consistent with the Desktop Entry appearance and containing what the user looks for;
7. The Shell script opens the document using the user's favorite editor so the user does not suspect anything and get what he wants;
8. The Shell script cleans stuff behind him.


How to
------

Just run `make` and you will find a file named `chaton-mignon.tgz` in the `build/` dir.

With your common File Manager you can right-click on this archive and click on _"Extract here"_, then a file is extracted right to the archive, appearing as `chaton-mignon.odt` with a common document icon in your file manager, mimicking an _Open Document Text_ file. If you double-click on this file, your favorite editor for Open Document Text file (for instance _LibreOffice_) will open a valid Open Document Text file named like the file displayed by your file manager and containing what you expect. At the same time, some arbitrary malicious code is executed, here it is a small python script that does some _[D-Bus](http://www.freedesktop.org/wiki/Software/dbus/)_ stuff designed deliberately to not be unadvertised for demonstration purpose, but you can do whatever you want to.

Right after is a sample-file if you want to look at tit, but if you want to execute it to see how it works for real, please do not use it, never trust something you find on the Internet! So this is the complete procedure to rebuild the file, and do not miss any step!

```
# clone the repository
git clone https://github.com/illwieckz/chaton-mignon.git

# walk in the source tree
cd chaton-mignon

# read dutifully all files included in this repository
vim $(find * -type f)

# build the file
make
```


Sample
------

You can find a built sample here: [chaton-mignon.tgz](http://dl.illwieckz.net/b/chaton-mignon/chaton-mignon.tgz).


Author
------

Thomas Debesse <dev@illwieckz.net>


Copyright
---------

This script is distributed under the highly permissive and laconic [ISC License](COPYING.md).
