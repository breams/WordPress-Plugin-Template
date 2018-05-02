WordPress Plugin Template
=========================

A robust and GPL-licensed code template for creating a standards-compliant WordPress plugin.

## Why this template?

After writing many WordPress plugins I slowly developed my own coding style and way of doing things - this template is the culmination of what I've learnt along the way. I use this template as a base for any plugin that I start building and I thought it might benefit more people if I shared it around.

## How do I use it?

You can simply copy the files out of this repo and rename everything as you need it, but to make things easier I have included a [shell script](build-plugin.sh) in this repo that will automatically copy the files to a new folder, remove all traces of the existing git repo, rename everything in the files according to your new plugin name, and initialise a new git repo in the folder if you choose to do so.

### Running the script

You can run the script just like you would run any shell script - it does not take any arguments, so you don't need to worry about that. Once you start the script it will ask a number of questions:

1. **Plugin name (required)** - this must be the full name of your plugin, with correct capitalisation and spacing.
2. **Destination folder (required)** - this will be the folder where your new plugin will be created - typically this will be your `wp-content/plugins` folder. You can provide a path that is relative to the script, or an absolute path - either will work.
4. **Author name (required)** - name of the plugin author(s). For multiple authors, please use a comma separated list.
3. **Plugin URL (optional)** - this is the reference URL for the plugin. Please include a full and correct URL as it is not validated. You can optionally skip this question to remove this field.
5. **Author URL (optional)** - this is the contact/reference URL for the plugin author(s). Please include a full and correct URL as it is not validated. You can optionally skip this question to remove this field.
6. **Contributors (optional - defaults to author name)** - this is the wordpress.org usernames of plugin developers/contributors - comma separated. You can optionally skip this question to use the value from `Author name`.
7. **Text Domain (optional - defaults to slug)** - this is the string used for language translation in the plugin. You can optionally skip this question to use the plugin's slug.
8. **Include Grunt support (Y/n)** - enter 'y' to include the Grunt files in the new plugin folder or 'n' to exclude them. Defaults to 'y'.
9. **Initialise new git repo (y/N)** - enter 'y' to initialise a new git repository in the new plugin folder or 'n' to skip. Defaults to 'n'.

### API functions

As of v3.0 of this template, there are a few libraries built into it that will make a number of common tasks a lot easier. I will expand on these libraries in future versions.

#### Registering a new post type

Using the [post type API](includes/lib/class-wordpress-plugin-template-post-type.php) and the wrapper function from the main plugin class you can easily register new post types with one line of code. For exapmle if you wanted to register a `listing` post type then you could do it like this:

`WordPress_Plugin_Template()->register_post_type( 'listing', __( 'Listings', 'wordpress-plugin-template' ), __( 'Listing', 'wordpress-plugin-template' ) );`

*Note that the `WordPress_Plugin_Template()` function name and the `wordpress-plugin-template` text domain will each be unique to your plugin after you have used the cloning script.*

This will register a new post type with all the standard settings. If you would like to modify the post type settings you can use the `{$post_type}_register_args` filter. See [the WordPress codex page](http://codex.wordpress.org/Function_Reference/register_post_type) for all available arguments.

#### Registering a new taxonomy

Using the [taxonomy API](includes/lib/class-wordpress-plugin-template-taxonomy.php) and the wrapper function from the main plugin class you can easily register new taxonomies with one line of code. For example if you wanted to register a `location` taxonomy that applies to the `listing` post type then you could do it like this:

`WordPress_Plugin_Template()->register_taxonomy( 'location', __( 'Locations', 'wordpress-plugin-template' ), __( 'Location', 'wordpress-plugin-template' ), 'listing' );`

*Note that the `WordPress_Plugin_Template()` function name and the `wordpress-plugin-template` text domain will each be unique to your plugin after you have used the cloning script.*

This will register a new taxonomy with all the standard settings. If you would like to modify the taxonomy settings you can use the `{$taxonomy}_register_args` filter. See [the WordPress codex page](http://codex.wordpress.org/Function_Reference/register_taxonomy) for all available arguments.

#### Calling your Options

Using the [Settings API](includes/class-wordpress-plugin-template-settings.php) and the wrapper function from the main plugin class you can easily store options from the WP admin like text boxes, radio options, dropdown, etc. You can call the values by using `id` that you have set under the `settings_fields` function. For example you have the `id` - `text_field`, you can call its value by using `get_option('wpt_text_field')`. Take note that by default, this plugin is using a prefix of `wpt_` before the id that you will be calling, you can override that value by changing it under the `__construct` function `$this->base` variable;

## What does this template give me?

This template includes the following features:

+ Plugin headers as required by WordPress & WordPress.org
+ Readme.txt file as required by WordPress.org
+ Main plugin class
+ Full & minified Javascript files
+ Grunt.js support
+ Standard enqueue functions for the dashboard and the frontend
+ A library for easily registering a new post type
+ A library for easily registering a new taxonomy
+ A library for handling common admin functions (including adding meta boxes to any post type, displaying settings fields and display custom fields for posts)
+ A complete and versatile settings class like you see [here](http://www.hughlashbrooke.com/complete-versatile-options-page-class-wordpress-plugin/)
+ A .pot file to make localisation easier
+ Full text of the GPLv2 license

See the [changelog](changelog.txt) for a complete list of changes as the template develops.

## I've got an idea/fix for the template

If you would like to contribute to this template then please fork it and send a pull request. I'll merge the request if it fits into the goals for the template and credit you in the [changelog](changelog.txt).

## This template is amazing! How can I ever repay you?

There's no need to credit me in your code for this template, just go forth and use it to make the WordPress experience a little better.
