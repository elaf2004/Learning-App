<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Course;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Storage;

class CourseController extends Controller
{
    // GET /api/v1/courses?category=Flutter&search=&per_page=10
    public function index(Request $req)
    {
        $per = min(max((int)$req->get('per_page', 10), 1), 100);

        $q = Course::query()
            ->with(['teacher:id,name,avatar'])
            ->withCount('topics')
            ->when($req->filled('category'), fn($qq) =>
                $qq->where('category', $req->category))
            ->when($req->filled('search'), fn($qq) =>
                $qq->where(function($w) use ($req) {
                    $w->where('title','like','%'.$req->search.'%')
                      ->orWhere('description','like','%'.$req->search.'%');
                }));

        $page = $q->latest()->paginate($per);
        // حوّل مسار الصورة إلى URL
        $page->getCollection()->transform(function ($c) {
            $c->image_url = $c->image ? asset('storage/'.$c->image) : null;
            return $c;
        });

        return response()->json($page);
    }

    // GET /api/v1/courses/{course}
    public function show(Course $course)
    {
        $course->load(['teacher:id,name,avatar','topics' => fn($q)=>$q->orderBy('order')]);
        $course->image_url = $course->image ? asset('storage/'.$course->image) : null;

        return response()->json($course);
    }

    // POST /api/v1/courses
    // multipart/form-data (image اختياري)
    public function store(Request $req)
    {
        $data = $req->validate([
            'title'       => ['required','string','max:255'],
            'price'       => ['required','numeric','min:0'],
            'category'    => ['required', Rule::in(['UI/UX','Animation','Design','Flutter','Python'])],
            'teacher_id'  => ['required','exists:teachers,id'],
            'description' => ['nullable','string'],
            'image'       => ['nullable','image','max:2048'],
        ]);

        if ($req->hasFile('image')) {
            $data['image'] = $req->file('image')->store('courses', 'public');
        }

        $course = Course::create($data);
        $course->image_url = $course->image ? asset('storage/'.$course->image) : null;

        return response()->json($course, 201);
    }

    // PUT/PATCH /api/v1/courses/{course}
    public function update(Request $req, Course $course)
    {
        $data = $req->validate([
            'title'       => ['sometimes','string','max:255'],
            'price'       => ['sometimes','numeric','min:0'],
            'category'    => ['sometimes', Rule::in(['UI/UX','Animation','Design','Flutter','Python'])],
            'teacher_id'  => ['sometimes','exists:teachers,id'],
            'description' => ['sometimes','nullable','string'],
            'image'       => ['sometimes','nullable','image','max:2048'],
        ]);

        if ($req->hasFile('image')) {
            // حذف القديم إن وجد
            if ($course->image) Storage::disk('public')->delete($course->image);
            $data['image'] = $req->file('image')->store('courses', 'public');
        }

        $course->update($data);
        $course->image_url = $course->image ? asset('storage/'.$course->image) : null;

        return response()->json($course);
    }

    // DELETE /api/v1/courses/{course}
    public function destroy(Course $course)
    {
        if ($course->image) Storage::disk('public')->delete($course->image);
        $course->delete();
        return response()->json(null, 204);
    }
}
