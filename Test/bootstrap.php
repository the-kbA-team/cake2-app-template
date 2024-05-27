<?php
/**
 * Web Access Frontend for TestSuite
 *
 * CakePHP(tm) Tests <http://book.cakephp.org/2.0/en/development/testing.html>
 * Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice
 *
 * @copyright     Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://book.cakephp.org/2.0/en/development/testing.html
 * @package       app.webroot
 * @since         CakePHP(tm) v 1.2.0.4433
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

set_time_limit(0);
ini_set('display_errors', 1);

if (!defined('DS')) {
    define('DS', DIRECTORY_SEPARATOR);
}

if (!defined('ROOT')) {
    define('ROOT', dirname(__FILE__, 2));
}

if (!defined('APP_DIR')) {
    define('APP_DIR', '');
}

if (!defined('APP')) {
    define('APP', ROOT . DS . APP_DIR . DS);
}

if (!defined('WEBROOT_DIR')) {
    define('WEBROOT_DIR', 'webroot');
}

if (!defined('WWW_ROOT')) {
    define('WWW_ROOT', APP . WEBROOT_DIR . DS);
}

$cakephpDir = \Composer\InstalledVersions::getInstallPath("kba-team/cakephp");
define('CAKE_CORE_INCLUDE_PATH', $cakephpDir . DS . 'lib');

$cakeBootstrapFile = CAKE_CORE_INCLUDE_PATH . DS . 'Cake' . DS . 'bootstrap.php';
$failed = false;
if (file_exists($cakeBootstrapFile)) {
    if (!include($cakeBootstrapFile)) {
        $failed = true;
    }
} else {
    $failed = true;
}

if (!empty($failed)) {
    trigger_error("CakePHP core could not be found.  Check the value of CAKE_CORE_INCLUDE_PATH.", E_USER_ERROR);
}

if (Configure::read('debug') < 1) {
    die(__d('cake_dev', 'Debug setting does not allow access to this url.'));
}

App::uses('CakeTestCase', 'TestSuite');
App::uses('CakeFixtureManager', 'TestSuite/Fixture');
