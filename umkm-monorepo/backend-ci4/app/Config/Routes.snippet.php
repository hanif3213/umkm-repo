<?php
// Tambahkan di app/Config/Routes.php (di bawah $routes->get('/', 'Home::index');)

$routes->group('api', ['namespace' => 'App\Controllers\Api'], static function ($routes) {
    $routes->resource('umkm', ['controller' => 'UmkmController', 'except' => 'new,edit']);
});
