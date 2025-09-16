<?php

namespace Database\Factories;

use App\Models\Course;
use Illuminate\Database\Eloquent\Factories\Factory;

class CourseTopicFactory extends Factory
{
    public function definition(): array
    {
        return [
            'course_id'        => Course::factory(),
            'title'            => $this->faker->sentence(4),
            'content'          => $this->faker->paragraph(),
            'order'            => 1, // سنضبطه في seeder بالترتيب
            'duration_minutes' => $this->faker->numberBetween(10, 60),
        ];
    }
}
