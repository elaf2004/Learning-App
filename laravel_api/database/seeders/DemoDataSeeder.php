<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Teacher;
use App\Models\Course;
use App\Models\CourseTopic;
use App\Models\UserCourseProgress;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DemoDataSeeder extends Seeder
{
    public function run(): void
    {
        // 1) مستخدمين أساسيين + 8 عشوائيين
        $alice = User::factory()->create([
            'name' => 'Alice',
            'email'=> 'alice@example.com',
            'password' => bcrypt('12345678'),
        ]);
        $bob = User::factory()->create([
            'name' => 'Bob',
            'email'=> 'bob@example.com',
            'password' => bcrypt('12345678'),
        ]);
        User::factory(8)->create();

        // 2) مدرّسين وكورسات
        $teachers = Teacher::factory(5)->create();

        // لكل مدرّس 3–5 كورسات
        $allCourses = collect();
        foreach ($teachers as $teacher) {
            $count = fake()->numberBetween(3,5);
            $courses = Course::factory($count)->create([
                'teacher_id' => $teacher->id,
            ]);

            // 3) مواضيع لكل كورس (4–8) بترتيب order متسلسل
            foreach ($courses as $course) {
                $topicsCount = fake()->numberBetween(4,8);
                $topics = collect();
                for ($i=1; $i<=$topicsCount; $i++) {
                    $topics->push(CourseTopic::factory()->create([
                        'course_id' => $course->id,
                        'order'     => $i,
                    ]));
                }
                // خزّن للتقدّم لاحقاً
                $course->setRelation('topics', $topics);
            }

            $allCourses = $allCourses->merge($courses);
        }

        // 4) تقدّم المستخدمين في عدد من الكورسات (يراعي unique[user_id,course_id])
        $users = User::all();
        foreach ($users as $user) {
            $enrolled = $allCourses->random(fake()->numberBetween(2,5));
            foreach ($enrolled as $course) {
                $topics = $course->topics ?? CourseTopic::where('course_id',$course->id)->orderBy('order')->get();
                $last   = $topics->random();

                UserCourseProgress::updateOrCreate(
                    ['user_id'=>$user->id, 'course_id'=>$course->id],
                    [
                        'progress'      => fake()->numberBetween(0, 100),
                        'last_topic_id' => $last->id,
                    ]
                );
            }
        }
    }
}
