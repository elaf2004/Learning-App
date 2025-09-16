<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Course;
use App\Models\CourseTopic;
use Illuminate\Database\Eloquent\Factories\Factory;

class UserCourseProgressFactory extends Factory
{
    public function definition(): array
    {
        return [
            'user_id'   => User::factory(),
            'course_id' => Course::factory(),
            'progress'  => $this->faker->numberBetween(0, 100),
            'last_topic_id' => null, // نضبطه لاحقًا بعد إنشاء التوبكس
        ];
    }
}
