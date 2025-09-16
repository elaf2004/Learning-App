<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class TeacherFactory extends Factory
{
    public function definition(): array
    {
        return [
            'name'   => $this->faker->name(),
            'email'  => $this->faker->unique()->safeEmail(),
            'avatar' => "https://i.pravatar.cc/150?img=".$this->faker->numberBetween(1, 70),
            'bio'    => $this->faker->sentence(12),
        ];
    }
}
