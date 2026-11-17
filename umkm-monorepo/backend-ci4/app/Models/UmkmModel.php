<?php

namespace App\Models;

use CodeIgniter\Model;

class UmkmModel extends Model
{
    protected $table         = 'umkm';
    protected $primaryKey    = 'id';
    protected $returnType    = 'array';
    protected $allowedFields = ['nama_umkm', 'pemilik', 'alamat', 'kategori', 'kontak'];
    protected $useTimestamps = true;

    protected $validationRules = [
        'nama_umkm' => 'required|min_length[3]|max_length[100]',
        'pemilik'   => 'required|max_length[100]',
        'alamat'    => 'required|max_length[255]',
        'kategori'  => 'required|in_list[Kuliner,Fashion,Kerajinan,Jasa,Pertanian,Lainnya]',
        'kontak'    => 'required|regex_match[/^[0-9+\-]{8,20}$/]',
    ];

    protected $validationMessages = [
        'nama_umkm' => [
            'required'   => 'Nama UMKM wajib diisi',
            'min_length' => 'Nama UMKM minimal 3 karakter',
        ],
        'pemilik'  => ['required' => 'Pemilik wajib diisi'],
        'alamat'   => ['required' => 'Alamat wajib diisi'],
        'kategori' => [
            'required' => 'Kategori wajib diisi',
            'in_list'  => 'Kategori tidak valid',
        ],
        'kontak' => [
            'required'    => 'Kontak wajib diisi',
            'regex_match' => 'Kontak harus berupa angka (8-20 digit)',
        ],
    ];
}
