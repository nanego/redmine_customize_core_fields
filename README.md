Redmine plugin - Let's customize core fields
============

This Redmine plugin lets you customize core fields behaviour.

You will be able to hide or show core fields based on the user roles per project.

Screenshot
------------

![redmine_customize_core_fields configuration_example](assets/images/screenshot.png)

Installation
------------

This plugin is compatible with Redmine 2.1+ and has been successfully tested on Redmine 3.2.

Please apply general instructions for plugins [here](http://www.redmine.org/wiki/redmine/Plugins).

Note that this plugin now depends on this other plugin:
* **redmine_base_deface** [here](https://github.com/jbbarth/redmine_base_deface)

First download the source or clone the plugin and put it in the "plugins/" directory of your redmine instance. Note that this is crucial that the directory is named 'redmine_customize_core_fields'!

Then execute:

    $ bundle install
    $ rake redmine:plugins

And finally restart your Redmine instance.

Test status
------------

|Plugin branch| Redmine Version   | Test Status       |
|-------------|-------------------|-------------------|
|master       | master            | [![Build1][1]][5] |  
|master       | 4.1.1             | [![Build1][2]][5] |  
|master       | 4.0.7             | [![Build2][3]][5] |

[1]: https://travis-matrix-badges.herokuapp.com/repos/nanego/redmine_customize_core_fields/branches/master/1?use_travis_com=true
[2]: https://travis-matrix-badges.herokuapp.com/repos/nanego/redmine_customize_core_fields/branches/master/2?use_travis_com=true
[3]: https://travis-matrix-badges.herokuapp.com/repos/nanego/redmine_customize_core_fields/branches/master/3?use_travis_com=true
[5]: https://travis-ci.com/nanego/redmine_customize_core_fields


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
