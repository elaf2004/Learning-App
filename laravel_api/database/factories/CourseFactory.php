<?php

namespace Database\Factories;

use App\Models\Teacher;
use Illuminate\Database\Eloquent\Factories\Factory;

class CourseFactory extends Factory
{
    public function definition(): array
    {
        // الفئات المسموحة من enum
        $categories = ['UI/UX','Animation','Design','Flutter','Python'];

        // مجموعة صور ثابتة (مضمونة)
        $images = [
            'https://placehold.co/600x400?text=UI%2FUX',
            'https://placehold.co/600x400?text=Animation',
            'https://placehold.co/600x400?text=Design',
            'https://placehold.co/600x400?text=Flutter',
            'https://placehold.co/600x400?text=Python',
        ];

        return [
            'title'       => $this->faker->unique()->sentence(3),
            'price'       => $this->faker->randomFloat(2, 0, 199),
            'image'       => $this->faker->randomElement($images), // صورة أكيدة
            'category'    => $this->faker->randomElement($categories), // فئة من enum
            'teacher_id'  => Teacher::factory(),
            'description' => $this->faker->paragraph(3),
        ];
    }
}
