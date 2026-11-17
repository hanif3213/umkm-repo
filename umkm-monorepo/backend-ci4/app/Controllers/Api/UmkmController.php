<?php

namespace App\Controllers\Api;

use App\Models\UmkmModel;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\RESTful\ResourceController;

/**
 * CRUD UMKM. Semua response memakai format baku:
 * { success, message, data, meta?, errors? }
 *
 * @property UmkmModel $model
 */
class UmkmController extends ResourceController
{
    protected $modelName = UmkmModel::class;
    protected $format    = 'json';

    private function apiOk(string $message, $data = null, ?array $meta = null, int $code = 200): ResponseInterface
    {
        $body = ['success' => true, 'message' => $message, 'data' => $data];
        if ($meta !== null) {
            $body['meta'] = $meta;
        }
        return $this->respond($body, $code);
    }

    private function apiFail(string $message, int $code, $errors = null): ResponseInterface
    {
        $body = ['success' => false, 'message' => $message];
        if ($errors !== null) {
            $body['errors'] = $errors;
        }
        return $this->respond($body, $code);
    }

    private function payload(): array
    {
        $json = $this->request->getJSON(true);
        $raw  = is_array($json) ? $json : ($this->request->getRawInput() ?: $this->request->getPost());
        return array_intersect_key($raw ?? [], array_flip($this->model->allowedFields));
    }

    /** GET /api/umkm?page=1&per_page=10&q=kopi&kategori=Kuliner */
    public function index()
    {
        $page    = max(1, (int) ($this->request->getGet('page') ?? 1));
        $perPage = min(100, max(1, (int) ($this->request->getGet('per_page') ?? 10)));
        $q       = trim((string) $this->request->getGet('q'));
        $kat     = trim((string) $this->request->getGet('kategori'));

        if ($q !== '') {
            $this->model->groupStart()->like('nama_umkm', $q)->orLike('pemilik', $q)->groupEnd();
        }
        if ($kat !== '') {
            $this->model->where('kategori', $kat);
        }

        $total = $this->model->countAllResults(false);
        $rows  = $this->model->orderBy('id', 'DESC')->findAll($perPage, ($page - 1) * $perPage);

        return $this->apiOk('Data UMKM berhasil diambil', $rows, [
            'page'        => $page,
            'per_page'    => $perPage,
            'total'       => $total,
            'total_pages' => (int) ceil($total / $perPage),
        ]);
    }

    /** GET /api/umkm/{id} */
    public function show($id = null)
    {
        $row = $this->model->find($id);
        if (! $row) {
            return $this->apiFail('Data UMKM tidak ditemukan', 404);
        }
        return $this->apiOk('Data UMKM berhasil diambil', $row);
    }

    /** POST /api/umkm */
    public function create()
    {
        $data = $this->payload();
        $id   = $this->model->insert($data);

        if ($id === false) {
            return $this->apiFail('Gagal menambahkan data UMKM', 400, $this->model->errors());
        }
        return $this->apiOk('Data UMKM berhasil ditambahkan', $this->model->find($id), null, 201);
    }

    /** PUT /api/umkm/{id} */
    public function update($id = null)
    {
        if (! $this->model->find($id)) {
            return $this->apiFail('Data UMKM tidak ditemukan', 404);
        }
        if ($this->model->update($id, $this->payload()) === false) {
            return $this->apiFail('Gagal memperbarui data UMKM', 400, $this->model->errors());
        }
        return $this->apiOk('Data UMKM berhasil diperbarui', $this->model->find($id));
    }

    /** DELETE /api/umkm/{id} */
    public function delete($id = null)
    {
        $row = $this->model->find($id);
        if (! $row) {
            return $this->apiFail('Data UMKM tidak ditemukan', 404);
        }
        $this->model->delete($id);
        return $this->apiOk('Data UMKM berhasil dihapus', ['id' => (int) $row['id'], 'nama_umkm' => $row['nama_umkm']]);
    }
}
