<?php
/**
 * Plugin Name:       __PLUGIN_NAME__
 * Version:           1.0.0
 * Plugin URI:        __PLUGIN_URL__
 * Description:       This is your starter template for your next WordPress plugin.
 * Author:            __AUTHOR_NAME__
 * Author URI:        __AUTHOR_URL__
 * Requires at least: 4.4
 * Tested up to:      4.9
 * Text Domain:       __TEXT_DOMAIN__
 * Domain Path:       /languages/
 *
 * @package WordPress_Plugin_Template
 * @author  __AUTHOR_NAME__
 * @since   1.0.0
 */

// If this file is called directly, abort.
if ( ! defined( 'WPINC' ) ) {

	die;

}

// Load plugin class files.
require_once( 'includes/class-wordpress-plugin-template.php' );
require_once( 'includes/class-wordpress-plugin-template-settings.php' );

// Load plugin libraries.
require_once( 'includes/lib/class-wordpress-plugin-template-admin-api.php' );
require_once( 'includes/lib/class-wordpress-plugin-template-post-type.php' );
require_once( 'includes/lib/class-wordpress-plugin-template-taxonomy.php' );

/**
 * Returns the main instance of WordPress_Plugin_Template to
 * prevent the need to use globals.
 *
 * @since  1.0.0
 * @return object WordPress_Plugin_Template
 */
function WordPress_Plugin_Template() {

	$instance = WordPress_Plugin_Template::instance( __FILE__, '1.0.0' );

	if ( is_null( $instance->settings ) ) {

		$instance->settings = WordPress_Plugin_Template_Settings::instance( $instance );

	}

	return $instance;

}

WordPress_Plugin_Template();
