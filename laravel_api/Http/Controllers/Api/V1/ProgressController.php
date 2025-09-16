<?php
// app/Http/Controllers/Api/V1/ProgressController.php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\UserCourseProgress;
use Illuminate\Http\Request;

class ProgressController extends Controller
{
    /**
     * GET /api/v1/my-courses
     * يمكن للأدمن تمرير ?user_id=.. (يفضّل تضيف تحقّق صلاحيات لاحقاً)
     * Output: List<MyCoursesModel-compatible>
     */
    public function index(Request $req)
    {
        $authUser = $req->user();
        if (!$authUser) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $targetUserId = (int) ($req->query('user_id', $authUser->id));
        // TODO: تحقق صلاحيات الأدمن لو targetUserId != $authUser->id

        $rows = UserCourseProgress::query()
            ->where('user_id', $targetUserId)
            ->with([
                'course' => function ($q) {
                    $q->select('id','title','image','teacher_id')
                      ->with(['teacher:id,name,avatar'])
                      ->withCount('topics') // topics_count
                      ->withSum('topics as total_duration_minutes', 'duration_minutes');
                }
            ])
            ->get(['course_id','progress','last_topic_id','updated_at']);

        $items = $rows->map(function ($p) {
            $c = $p->course;
            if (!$c) return null;

            // progress: نفترض UserCourseProgress.progress عدد صحيح 0..100
            $percent = (int) ($p->progress ?? 0);
            $percent = max(0, min(100, $percent));
            $progress01 = $percent / 100;

            $totalMinutes     = (int) ($c->total_duration_minutes ?? 0);
            $completedMinutes = (int) round($totalMinutes * $progress01);
            $remainingMinutes = max(0, $totalMinutes - $completedMinutes);

            return [
                'courseId'        => (int) $c->id,
                'title'           => (string) $c->title,
                'author'          => optional($c->teacher)->name ?? '—',
                'image'           => (string) ($c->image ?? ''),

                'percent'         => $percent,                        // 0..100
                'percentLabel'    => "{$percent}% to complete",
                'progress'        => (float) $progress01,             // 0.0..1.0

                'timeLeftMinutes' => $remainingMinutes,
                'timeLeftLabel'   => self::humanMinutes($remainingMinutes),

                'lessons'         => (int) ($c->topics_count ?? 0),

                'durationMinutes' => $totalMinutes,
                'durationLabel'    => self::humanMinutes($totalMinutes),
            ];
        })->filter()->values();

        return response()->json($items, 200);
    }

    private static function humanMinutes(int $minutes): string
    {
        $h = intdiv($minutes, 60);
        $m = $minutes % 60;
        if ($h > 0 && $m > 0) return "{$h}h {$m}m";
        if ($h > 0) return "{$h}h";
        return $m > 0 ? "{$m}min" : "0min";
    }
}
