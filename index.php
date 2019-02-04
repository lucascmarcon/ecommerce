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

    $sql = new main\database\mysql\Sql();
    $result = $sql->select("SELECT * FROM persons");
    header("Content-Type: application/json");
    echo json_encode($result);
});

$app->run();