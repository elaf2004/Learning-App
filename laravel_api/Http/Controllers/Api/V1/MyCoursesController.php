<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Course;
use App\Models\UserCourseProgress;
use Illuminate\Http\Request;

class MyCoursesController extends Controller
{
    /**
     * GET /api/v1/my/courses
     * يدعم فلاتر اختيارية: ?category=Flutter&search=ui
     * ويدعم pagination: ?page=1
     */
    public function index(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        // فلاتر اختيارية
        $category = $request->query('category'); // UI/UX, Animation, Design, Flutter, Python
        $search   = $request->query('search');   // يبحث في العنوان/الوصف

        // اجلب progress كساب كويري نضمه للرد
        $progressSub = UserCourseProgress::select('progress')
            ->whereColumn('user_course_progress.course_id', 'courses.id')
            ->where('user_id', $user->id)
            ->limit(1);

        $lastTopicSub = UserCourseProgress::select('last_topic_id')
            ->whereColumn('user_course_progress.course_id', 'courses.id')
            ->where('user_id', $user->id)
            ->limit(1);

        // الكورسات التي للمستخدم (المسجّل فيها)
        $query = Course::query()
            ->whereIn('id', function ($q) use ($user) {
                $q->from('user_course_progress')
                  ->select('course_id')
                  ->where('user_id', $user->id);
            })
            ->with(['teacher:id,name,avatar'])
            ->withCount('topics')
            ->withSum('topics as total_duration_minutes', 'duration_minutes')
            ->addSelect([
                'user_progress'  => $progressSub,
                'last_topic_id'  => $lastTopicSub,
            ])
            ->orderByDesc('updated_at');

        if ($category) {
            $query->where('category', $category);
        }
        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('description', 'like', "%{$search}%");
            });
        }

        // Paginate (يمكنك تحويلها إلى get() إن أردت كل النتائج)
        $courses = $query->paginate(10);

        // صياغة الرد بشكل موحّد
        $data = $courses->through(function ($c) {
            return [
                'id'          => $c->id,
                'title'       => $c->title,
                'category'    => $c->category,
                'price'       => $c->price,
                'image'       => $c->image,
                'teacher'     => $c->teacher ? [
                    'id'     => $c->teacher->id,
                    'name'   => $c->teacher->name,
                    'avatar' => $c->teacher->avatar,
                ] : null,
                'topics_count'           => (int) $c->topics_count,
                'total_duration_minutes' => (int) ($c->total_duration_minutes ?? 0),
                'progress_percent'       => (int) ($c->user_progress ?? 0), // من جدول user_course_progress
                'last_topic_id'          => $c->last_topic_id,
                'updated_at'             => $c->updated_at,
            ];
        });

        return response()->json([
            'data' => $data,
            'meta' => [
                'current_page' => $courses->currentPage(),
                'last_page'    => $courses->lastPage(),
                'per_page'     => $courses->perPage(),
                'total'        => $courses->total(),
            ],
        ]);
    }
}
