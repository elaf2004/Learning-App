<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Teacher;
use Illuminate\Http\Request;

class TeacherController extends Controller
{
    // GET /api/v1/teachers?search=&per_page=10
    public function index(Request $req)
    {
        $per = min(max((int)$req->get('per_page', 10), 1), 100);
        $q = Teacher::query()
            ->when($req->filled('search'), fn($qq) =>
                $qq->where('name','like','%'.$req->search.'%')
                   ->orWhere('email','like','%'.$req->search.'%'));

        return response()->json($q->latest()->paginate($per));
    }

    // GET /api/v1/teachers/{id}
    public function show(Teacher $teacher)
    {
        // مع الكورسات المرتبطة (count فقط لتخفيف الحجم)
        $teacher->loadCount('courses');
        return response()->json($teacher);
    }
}
