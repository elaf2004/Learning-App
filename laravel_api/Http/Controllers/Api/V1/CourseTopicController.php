<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Course;
use App\Models\CourseTopic;
use Illuminate\Http\Request;

class CourseTopicController extends Controller
{
    // GET /api/v1/courses/{course}/topics
    public function index(Course $course)
    {
        $topics = $course->topics()->orderBy('order')->get();
        return response()->json(['course_id'=>$course->id,'topics'=>$topics]);
    }

    // POST /api/v1/courses/{course}/topics
    public function store(Request $req, Course $course)
    {
        $data = $req->validate([
            'title' => ['required','string','max:255'],
            'content' => ['nullable','string'],
            'order' => ['nullable','integer','min:1'],
            'duration_minutes' => ['nullable','integer','min:1'],
        ]);

        // أعطِ ترتيب تلقائي إن لم يرسل
        if (!isset($data['order'])) {
            $max = (int) $course->topics()->max('order');
            $data['order'] = $max + 1;
        }

        $topic = $course->topics()->create($data);
        return response()->json($topic, 201);
    }

    // PUT/PATCH /api/v1/topics/{topic}
    public function update(Request $req, CourseTopic $topic)
    {
        $data = $req->validate([
            'title' => ['sometimes','string','max:255'],
            'content' => ['sometimes','nullable','string'],
            'order' => ['sometimes','integer','min:1'],
            'duration_minutes' => ['sometimes','integer','min:1'],
        ]);
        $topic->update($data);
        return response()->json($topic);
    }

    // DELETE /api/v1/topics/{topic}
    public function destroy(CourseTopic $topic)
    {
        $topic->delete();
        return response()->json(null, 204);
    }
}
