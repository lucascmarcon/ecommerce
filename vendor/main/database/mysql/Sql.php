<?php
/**
 * Created by PhpStorm.
 * User: lucasmarcon
 * Date: 04/02/19
 * Time: 03:34
 */

namespace main\database\mysql;


class Sql
{
    const HOSTNAME  = "127.0.0.1";
    const USERNAME  = "root";
    const PASSWORD  = "";
    const DBNAME    = "ecommerce";

    private $connecction;

    public function __construct()
    {
        $this->connecction = new \PDO (
            "mysql:host=".Sql::HOSTNAME.";dbname=".Sql::DBNAME,
            Sql::USERNAME,
            Sql::PASSWORD
        );
    }

    public function bindParameters($statement, $key, $value)
    {
        $statement->bindParam($key, $value);
    }
    
    public function setParameters($statement, $parameters = array())
    {
        foreach ($parameters as $key => $value)
            $this->bindParameters($statement, $key, $value);
    }

    public function query($rawQuery, $parameters = array())
    {
        $statement = $this->connecction->prepare($rawQuery);
        $this->setParameters($statement, $parameters);
        $statement->execute();
    }

    public function select($rawQuery, $parameters = array()):array
    {
        $statement = $this->connecction->prepare($rawQuery);
        $this->setParameters($statement, $parameters);
        $statement->execute();
        return $statement->fetchAll(\PDO::FETCH_ASSOC);
    }
}