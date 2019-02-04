<?php
/**
 * Created by PhpStorm.
 * User: lucasmarcon
 * Date: 04/02/19
 * Time: 02:18
 */

require_once("vendor/autoload.php");

$app = new \Slim\Slim();

$app->config('debug', true);

$app->get('/', function() {

    echo "OK";

});

$app->run();